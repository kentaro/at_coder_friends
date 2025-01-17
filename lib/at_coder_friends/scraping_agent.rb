# frozen_string_literal: true

require 'uri'
require 'mechanize'
require 'logger'
require 'English'

module AtCoderFriends
  # scrapes AtCoder contest site and
  # - fetches problems
  # - submits sources
  class ScrapingAgent
    include PathUtil

    BASE_URL = 'https://atcoder.jp/'
    XPATH_SECTION = '//h3[.="%<title>s"]/following-sibling::section'
    LANG_TBL = {
      'cxx'  => '3003',
      'cs'   => '3006',
      'java' => '3016',
      'rb'   => '3024'
    }.freeze

    attr_reader :contest, :config, :agent

    def initialize(contest, config)
      @contest = contest
      @config = config
      @agent = Mechanize.new
      @agent.pre_connect_hooks << proc { sleep 0.1 }
      # @agent.log = Logger.new(STDERR)
    end

    def common_url(path)
      File.join(BASE_URL, path)
    end

    def contest_url(path)
      File.join(BASE_URL, 'contests', contest, path)
    end

    def constraints_pat
      config['constraints_pat'] || '^制約$'
    end

    def input_fmt_pat
      config['input_fmt_pat'] || '^入出?力$'
    end

    def input_smp_pat
      config['input_smp_pat'] || '^入力例\s*(?<no>[\d０-９]+)$'
    end

    def output_smp_pat
      config['output_smp_pat'] || '^出力例\s*(?<no>[\d０-９]+)$'
    end

    def fetch_all
      puts "***** fetch_all #{@contest} *****"
      login
      fetch_assignments.map do |q, url|
        pbm = fetch_problem(q, url)
        yield pbm if block_given?
        pbm
      end
    end

    def submit(path)
      path, _dir, prg, _base, ext, q = split_prg_path(path)
      puts "***** submit #{prg} *****"
      src = File.read(path, encoding: Encoding::UTF_8)
      login
      post_src(q, ext, src)
    end

    def login
      page = agent.get(common_url('login'))
      form = page.forms[1]
      form.field_with(name: 'username').value = config['user']
      form.field_with(name: 'password').value = config['password']
      form.submit
    end

    def fetch_assignments
      url = contest_url('tasks')
      puts "fetch list from #{url} ..."
      page = agent.get(url)
      page
        .search('//table[1]//td[1]//a')
        .each_with_object({}) do |a, h|
          h[a.text] = a[:href]
        end
    end

    def fetch_problem(q, url)
      puts "fetch problem from #{url} ..."
      page = agent.get(url)
      Problem.new(q) do |pbm|
        pbm.html = page.body
        if contest == 'arc001'
          page.search('//h3').each do |h3|
            query = format(XPATH_SECTION, title: h3.content)
            sections = page.search(query)
            sections[0] && parse_section(pbm, h3, sections[0])
          end
        else
          page.search('//*[./h3]').each do |section|
            h3 = section.search('h3')[0]
            parse_section(pbm, h3, section)
          end
        end
      end
    end

    def parse_section(pbm, h3, section)
      title = h3.content.strip
      title.delete!("\u008f\u0090") # agc002
      text = section.content
      code = section.search('pre')[0]&.content || ''
      case title
      when /#{constraints_pat}/
        pbm.desc += text
      when /#{input_fmt_pat}/
        pbm.desc += text
        pbm.fmt = code
      when /#{input_smp_pat}/
        pbm.add_smp($LAST_MATCH_INFO[:no], :in, code)
      when /#{output_smp_pat}/
        pbm.add_smp($LAST_MATCH_INFO[:no], :exp, code)
      end
    end

    def post_src(q, ext, src)
      lang_id = LANG_TBL[ext.downcase]
      raise AppError, ".#{ext} is not available." unless lang_id
      page = agent.get(contest_url('submit'))
      form = page.forms[1]
      form.field_with(name: 'data.TaskScreenName') do |sel|
        option = sel.options.find { |op| op.text.start_with?(q) }
        option&.select || (raise AppError, "unknown problem:#{q}.")
      end
      form.add_field!('data.LanguageId', lang_id)
      form.field_with(name: 'sourceCode').value = src
      form.submit
    end
  end
end
