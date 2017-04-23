module Exceptions
  class ApiError < StandardError
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
    { name: :UserExistsError, message: "This user already exists in the database, pick another name"},
  ]

  errors.each do |name:, type: name.to_s.chomp('Error'), message:, status: 400|
    klass = Class.new(ApiError) do
      @type = type
      @message = message
      @status = status
      class << self
        attr_reader :type, :message, :status
      end
      def initialize(**kwargs)
        klass = self.class
        super(kwargs[:type] || klass.type, kwargs[:message] || klass.message, kwargs[:status] || klass.status)
      end
    end
    self.const_set name, klass
  end
end
