# frozen_string_literal: true

RSpec.describe AtCoderFriends::ScrapingAgent do
  include_context :atcoder_env
  include_context :atcoder_stub

  subject(:agent) { described_class.new(contest, config) }
  let(:contest) { 'arc001' }
  let(:config) { { 'user' => 'foo', 'password' => 'bar' } }

  describe '#fetch_all' do
    subject { agent.fetch_all }

    after(:all) { FileUtils.rm(Dir.glob(smp_dir + '/*.out')) }

    # TODO: yield test
    context 'from ARC#001' do
      it 'fetches problems' do
        expect { subject }.to output(
          <<~TEXT
            ***** fetch_all arc001 *****
            fetch list from https://atcoder.jp/contests/arc001/tasks ...
            fetch problem from /contests/arc001/tasks/arc001_1 ...
            fetch problem from /contests/arc001/tasks/arc001_2 ...
            fetch problem from /contests/arc001/tasks/arc001_3 ...
            fetch problem from /contests/arc001/tasks/arc001_4 ...
          TEXT
        ).to_stdout
        expect(subject.size).to eq(4)
        expect(subject[0]).to have_attributes(q: 'A')
        expect(subject[1]).to have_attributes(q: 'B')
        expect(subject[2]).to have_attributes(q: 'C')
        expect(subject[3]).to have_attributes(q: 'D')
      end
    end

    context 'from practice' do
      let(:contest) { 'practice' }

      it 'fetches problems' do
        expect { subject }.to output(
          <<~TEXT
            ***** fetch_all practice *****
            fetch list from https://atcoder.jp/contests/practice/tasks ...
            fetch problem from /contests/practice/tasks/practice_1 ...
            fetch problem from /contests/practice/tasks/practice_2 ...
          TEXT
        ).to_stdout
        expect(subject.size).to eq(2)
        expect(subject[0]).to have_attributes(q: 'A')
        expect(subject[1]).to have_attributes(q: 'B')
      end
    end
  end

  describe '#submit' do
    subject { agent.submit(File.join(contest_root, prg)) }

    context 'when there is no error' do
      let(:prg) { 'A.rb' }

      it 'posts the source' do
        expect { subject }.to \
          output("***** submit A.rb *****\n").to_stdout
        expect(subject).to be_a(Mechanize::Page)
      end
    end

    context 'for alt version' do
      let(:prg) { 'A_v2.rb' }

      it 'posts the source' do
        expect { subject }.to \
          output("***** submit A_v2.rb *****\n").to_stdout
        expect(subject).to be_a(Mechanize::Page)
      end
    end

    context 'for unsupported extension' do
      let(:prg) { 'A.py' }

      it 'show error' do
        expect { subject }.to \
          raise_error(AtCoderFriends::AppError, '.py is not available.')
      end
    end

    context 'for non-existent problem' do
      let(:prg) { 'Z.rb' }

      it 'show error' do
        expect { subject }.to \
          raise_error(AtCoderFriends::AppError, 'unknown problem:Z.')
      end
    end
  end
end
