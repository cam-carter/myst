module Myst
  class Interpreter
    NativeLib.method :io_read, MTValue, size : Int64 do
      __raise_runtime_error("`IO#read` must be implemented by inheriting types.")
    end

    NativeLib.method :io_write, MTValue, content : MTValue do
      __raise_runtime_error("`IO#write` must be implemented by inheriting types.")
    end

    private def make_io_fd(type : TType, id : Int)
      fd = TInstance.new(type)
      fd.ivars["@fd"] = id.to_i64
      fd
    end

    def init_io
      io_type = __make_type("IO", @kernel.scope)

      NativeLib.def_instance_method(io_type, :read, :io_read)
      NativeLib.def_instance_method(io_type, :write, :io_write)

      fd_type = init_file_descriptor(io_type)
      io_type.scope["FileDescriptor"] = fd_type

      @kernel.scope["STDIN"]    = make_io_fd(fd_type, 0)
      @kernel.scope["STDOUT"]   = make_io_fd(fd_type, 1)
      @kernel.scope["STDERR"]   = make_io_fd(fd_type, 2)

      file_type = init_file(fd_type)
      @kernel.scope["File"]     = file_type

      io_type
    end
  end
end
