# frozen_string_literal: true

require 'rails_helper'

describe Categories::CreateWithGroup do
  let(:budget) { create(:budget) }
  let(:params) do
    {
      budget_id: budget.id,
      name: Faker::Creature::Dog.name,
      group_name: Faker::Creature::Cat.name
    }
  end

  it 'creates a new category associated to the group with given group_name' do
    category_group = create(
      :category_group, budget: budget, name: params[:group_name]
    )

    category = described_class.call(params)

    expect(category).to have_attributes(
      name: params[:name],
      category_group: category_group,
    )
  end

  context 'when there is a category group with given group name' do
    it 'does not create a new category group' do
      create(:category_group, budget: budget, name: params[:group_name])

      expect do
        described_class.call(params) 
      end.not_to change { CategoryGroup.count }
    end
  end

  context 'when there is no category group with given group name' do
    it 'creates a new category group' do
      expect do
        described_class.call(params) 
      end.to change { CategoryGroup.count }.by(1)
    end
  end

  context 'when there is already a category with given name and group' do
    it 'raises DuplicateError' do
      category_group = create(
        :category_group, name: params[:group_name], budget: budget
      )
      create(:category, name: params[:name], category_group: category_group)

      expect do  
        described_class(params)
      end.to raise_error { Categories::DuplicateError.new }
    end
  end
end