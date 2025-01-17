# frozen_string_literal: true

module AtCoderFriends
  DataSample = Struct.new(:no, :ext, :txt) do
    def initialize(no, ext, txt)
      no = no.tr('０-９', '0-9').to_i
      txt = txt.lstrip.gsub("\r\n", "\n")
      super(no, ext, txt)
    end
  end

  InputDef = Struct.new(:container, :item, :names, :size) do
    def initialize(container, item, names, size = [])
      super(container, item, names, size)
    end
  end

  SourceSample = Struct.new(:ext, :txt)

  # holds problem information
  class Problem
    attr_reader :q, :fmt, :smps, :srcs
    attr_accessor :html, :desc, :defs

    def initialize(q)
      @q = q
      @html = ''
      @desc = ''
      @fmt = ''
      @smps = []
      @defs = []
      @srcs = []
      yield self if block_given?
    end

    def fmt=(f)
      @fmt = f.lstrip.gsub("\r\n", "\n")
    end

    def add_smp(no, ext, txt)
      @smps << DataSample.new(no, ext, txt)
    end

    def add_src(ext, txt)
      @srcs << SourceSample.new(ext, txt)
    end
  end
end
