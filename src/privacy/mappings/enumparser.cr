module Privacy
  module EnumParser(T)
    def self.from_json(parser)
      T.parse parser.read_string
    end

    def self.to_json(value, builder)
      value.to_s
    end
  end
end
