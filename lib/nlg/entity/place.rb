module Nlg
  module Entity
    module Place

      # == Supported Fields
      # * name
      # * population
      # * latitude
      # * longitude
      # * htemp
      # * ltemp
      # * altitude
      # * area
      # * rainfall

      SUPPORTED_FIELDS = %w(name population latitude longitude htemp ltemp altitude area rainfall)

      def subject
        name
      end

      def build_htemp(fields={})
        {
          'value' => send(:htemp),
          'specifications' => {
            'complement' => "\u00B0" + (fields[:complement] || "C")
          }
        }
      end

      def build_rainfall(fields = {})
        { 
          'value' => send(:rainfall),
          'specifications' => {
            'complement' => fields[:complement] || 'mm'
          }
        }
      end

      def build
        objects = {}
        self.class.nlg_fields.each do |name|
          if name.is_a?(Hash)
            key = name.keys.first.to_s
            objects[key] = send(:"build_#{key}", name.values.first)
          else
            objects[name.to_s] = send(:"build_#{name}")
          end
        end
        objects
      end

      def generate
        dataset = { 'subject' => name, 'objects' => build }
        paragraph = Nlg::Paragraph.new(dataset, defaults)
        paragraph.build
        paragraph.sentences.each do |sentence|
          puts sentence
        end
      end
      
      def defaults
        @defaults = {
          'tense' => "present",
          'verb' => "have",
          'pronoun' => "it",
          'voice' => "active",
          'aspect' => "habitual",
          'preposition' => "of"
        }
      end

    end
  end
end
