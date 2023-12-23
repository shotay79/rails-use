require 'colorize'

module Rails
  module Use
    module Railsserializer2schema
      class << self
        # def configuration
        #   @configuration ||= Configuration.new
        # end

        # def configure
        #   yield(configuration)
        # end

        def execute
          dir = './types'
          FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
          serializers_path = Dir.glob('app/serializers/**/*.rb')
          models = <<~TS
          TS
          serializers_path.each do |serializer_path|
            file_name = File.basename(serializer_path, '.rb')
            serializer_class = file_name.camelize.constantize
            interface = serializer_to_interface(serializer_class)

            models += interface
          end

          File.write(dir + '/models.d.ts', <<~TS
            import { z } from "zod";

          TS
          )
          File.write(dir + '/models.d.ts', models)
        end

        private

        def serializer_to_interface(serializer)
          serializer_attributes = serializer._attributes
          model_name = serializer.name.gsub('Serializer', '')
          model_class = model_name.constantize
          columns = model_class.columns_hash
          interface_types = serializer_attributes.map do |attribute|
            column = columns[attribute.to_s]
            type = if column.nil?
                     'unknown'
                   else
                     _type = type_to_interface_type(column.type)
                     if column.null
                       _type += ' | null'
                     end
                     _type
                   end
            { attribute.to_s.camelize(:lower) => type }
          end
          relation_types = OrderSerializer._reflections.map do |association|
            name = association[0].to_s.camelize(:lower)
            if association[1].is_a?(ActiveModel::Serializer::BelongsToReflection)
              next { "#{name}?" => name.camelize }
            end

            if association[1].is_a?(ActiveModel::Serializer::HasManyReflection)
              next { "#{name}?" => name.singularize.camelize + '[]' }
            end
          end
          <<~TS
            export interface #{model_name} {
              #{
                interface_types.map do |type|
                  type.keys[0] + ': ' + type.values[0]
                end.join("\n\t")
              }
              #{
                relation_types.map do |type|
                  type.keys[0] + ': ' + type.values[0]
                end.join("\n\t")
              }
            }

          TS
        end

        def type_to_interface_type(type)
          case type
          when :uuid, :datetime, :date, :text
            'string'
          when :integer
            'number'
          else
            type.to_s
          end
        end
      end
    end
  end
end
