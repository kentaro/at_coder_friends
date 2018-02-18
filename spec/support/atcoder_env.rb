# frozen_string_literal: true

shared_context :atcoder_env do
  before :all do
    spec_root = File.expand_path('..', __dir__)
    @project_root = File.join(spec_root, 'fixtures', 'AtCoder')
    @contest_root = File.join(@project_root, 'ARC#001')
    @smp_dir = File.join(@contest_root, 'data')
    @tmp_dir = File.join(@contest_root, '.tmp')
  end

  attr_reader :project_root, :contest_root, :smp_dir, :tmp_dir
end
