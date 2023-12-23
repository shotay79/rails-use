require 'colorize'

require_relative 'configuration'

module Rails
  module Use
    module Railsserializer2schema
      class << self
        def execute
          if Rails::Use.configuration.model_output_dir.blank?
            raise 'Please set Rails::Use.configuration.model_output_dir'
          end

          dir = Rails::Use.configuration.model_output_dir

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

          File.write(dir + '/index.ts', <<~TS
            import { z } from "zod";

            #{models}
          TS
          )
        end

        private

        def serializer_to_interface(serializer)
          serializer_attributes = serializer._attributes
          model_name = serializer.name.gsub('Serializer', '')
          model_class = model_name.constantize
          columns = model_class.columns_hash
          schema_name = model_name + 'Schema'
          interface_types = serializer_attributes.map do |attribute|
            column = columns[attribute.to_s]
            type = if column.nil?
                     'unknown'
                   else
                     _type = "z" + type_to_interface_type(column.type)
                     if column.null
                       _type += '.nullable()'
                     end
                     _type
                   end
            { attribute.to_s.camelize(:lower) => type }
          end
          relation_types = serializer._reflections.map do |association|
            name = association[0].to_s.camelize(:lower)
            if association[1].is_a?(ActiveModel::Serializer::BelongsToReflection)
              next { "#{name}?" => name.camelize }
            end

            if association[1].is_a?(ActiveModel::Serializer::HasManyReflection)
              next { "#{name}" => "z.array(#{name.singularize.camelize}Schema).optional()" }
            end
          end
          <<~TS
            export const #{schema_name} = z.object({
              #{
                [interface_types, relation_types].flatten.map do |type|
                  type.keys[0] + ': ' + type.values[0] + ','
                end.join("\n\t")
              }
            })

            export type #{model_name} = z.infer<typeof #{schema_name}>;

          TS
        end

        def type_to_interface_type(type)
          case type
          when :uuid, :datetime, :date, :text
            '.string()'
          when :integer
            '.number()'
          else
            ".#{type.to_s}()"
          end
        end
      end
    end
  end
end
