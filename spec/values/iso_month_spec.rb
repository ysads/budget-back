# frozen_string_literal: true

require 'rails_helper'

describe IsoMonth do
  describe '.of' do
    context 'when arg is a string' do
      it 'parses date and formats to YYYY-mm', :aggregate_failures do
        expect(IsoMonth.of('2021-04-29T14:58:30+00:00')).to eq('2021-04')
        expect(IsoMonth.of('20210101T145830Z')).to eq('2021-01')
        expect(IsoMonth.of('2021-12-31')).to eq('2021-12')
      end

      context 'when arg is a date' do
        it 'formats to YYYY-mm', :aggregate_failures do
          expect(IsoMonth.of(Date.parse('2021-04-29T14:58:30+00:00'))).to(
            eq('2021-04'),
          )
          expect(IsoMonth.of(Date.parse('20210101T145830Z'))).to eq('2021-01')
          expect(IsoMonth.of(Date.parse('2021-12-31'))).to eq('2021-12')
        end
      end
    end
  end
end
