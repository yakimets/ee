# Frame
# Maintains a list of drawing instructions to be written to the display

module Ivan
  class Frame
    attr_reader :instructions

    def initialize
      self.clear
    end

    def render(object_to_render)
      if object_to_render.respond_to?(:render)
        @instructions += (object_to_render.render)
      else
        return nil
      end
    end

    def clear
      @instructions = []
    end
  end
end