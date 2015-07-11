class OutputInitError < Exception
end

class UnsafeOutputError < Exception
end

# Sender is an abstract class, and is not meant to be instantiated.
# Subclass it for the requirements of your application's display hardware.

class Sender
  @output = nil
  @boundary = nil

  attr_reader :boundary

  def initialize(config_params)
    begin
      post_initialize(config_params)
    rescue
      raise OutputInitError, "Output device couldn't be initialized"
    end
  end

  def send(buffer)
    check_safe(buffer)
    pre_send(buffer)
    buffer.each_slice(2) do |slice|
      send_line(slice)
    end
  end

  private

    def check_safe(buffer)
      buffer.each do |i|
        raise UnsafeOutputError, "Found point #{i.inspect} outside output boundary #{@boundary.inspect}" \
          if (!i.screen_safe?(@boundary))
      end
    end

    def send_line(line)
      [line[0].x, line[0].y, line[1].x, line[1].y].each do |coord|
        @output.send(output_message, coordinate_format(coord) )
      end
    end

    # Override these methods in concrete subclasses

    def post_initialize(config_params)
      raise NotImplementedError
    end

    def pre_send(buffer)
      raise NotImplementedError
    end

    def output_message
      raise NotImplementedError
    end

    def coordinate_format(value)
      raise NotImplementedError
    end
end