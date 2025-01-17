# frozen_string_literal: true

module AtCoderFriends
  # run test cases for the specified program with actual input/output.
  class JudgeTestRunner < TestRunner
    include PathUtil

    def initialize(path)
      super(path)
      @cases_dir = cases_dir(@dir)
      @smp_dir = smp_dir(@dir)
    end

    def judge_all
      puts "***** judge_all #{@prg} *****"
      Dir["#{@cases_dir}/#{@q}/in/*.txt"].sort.each do |infile|
        id = File.basename(infile, '.txt')
        judge(id)
      end
    end

    def judge_one(id)
      puts "***** judge_one #{@prg} *****"
      judge(id)
    end

    def judge(id)
      infile = "#{@cases_dir}/#{@q}/in/#{id}.txt"
      outfile = "#{@smp_dir}/#{@q}_#{id}.out"
      expfile = "#{@cases_dir}/#{@q}/out/#{id}.txt"
      run_test(id, infile, outfile, expfile)
    end
  end
end
