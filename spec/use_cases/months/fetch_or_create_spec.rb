# frozen_string_literal: true

require 'rails_helper'

describe Months::FetchOrCreate do
  let(:params) do
    {
      budget_id: create(:budget).id,
      iso_month: IsoMonth.of(Faker::Date.in_date_period),
    }
  end

  context 'when already exists a month with given iso_month' do
    it 'returns the existing month' do
      create(:month, iso_month: params[:iso_month])

      month = described_class.call(params)

      expect(month).to have_attributes(params)
    end

    it 'does not create a new month' do
      create(
        :month, iso_month: params[:iso_month], budget_id: params[:budget_id]
      )

      expect do
        described_class.call(params)
      end.not_to change { Month.count }
    end
  end

  context 'when there is not a month with this iso_month' do
    it 'creates a new month', :aggregate_failures do
      expect do
        described_class.call(params)
      end.to change { Month.count }.by(1)

      expect(Month.last).to have_attributes(params)
    end
  end
end
