# frozen_string_literal: true
RSpec.describe(Hivelog) do
  it 'has a version number' do
    expect(Hivelog::VERSION).not_to(be(nil))
  end
end
