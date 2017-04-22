module Exceptions
  class ApiException < StandardError
    attr_reader :type, :message, :status
    def initialize(type, message, status)
      @type = type
      @message = message
      @status = status
    end

    def to_json(*args)
      { type: @type, message: @message }.to_json
    end
  end

  errors = [
    { name: :UnauthorizedError, message: "Please log in and try again", status: 403 },
  ]

  errors.each do |name:, type: name.to_s.chomp('Error'), message:, status: 400|
    klass = Class.new(ApiException) do
      @@type = type
      @@message = message
      @@status = status
      def initialize(**kwargs)
        super(kwargs[:type] || @@type, kwargs[:message] || @@message, kwargs[:status] || @@status)
      end
    end
    self.const_set name, klass
  end
end
