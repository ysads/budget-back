# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require('faker')

# ｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆
# 1. Users
user = User.create!(
  name: 'Test user',
  email: 'test@mail.com',
  password: '123456'
)

# ｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆
# 2. Budgets
budget = Budget.create!(
  name: 'EUR Budget',
  currency: 'EUR',
  date_format: 'dd.MM.YYYY',
  user: user
)

# ｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆
# 3. Categories & Category Groups
groups = ['Fixed', 'Variable', 'Subscriptions', 'Savings'].map do |group_name|
  CategoryGroup.create!(
    budget: budget,
    name: group_name
  )
end
['Rent', 'Heat', 'Internet', 'Electricity'].map do |cat_name|
  Category.create!(
    category_group: groups[0],
    name: cat_name
  )
end
['Groceries', 'Eating out'].map do |cat_name|
  Category.create!(
    category_group: groups[1],
    name: cat_name
  )
end
['Netflix', 'Amazon Prime', 'Disney Plus'].map do |cat_name|
  Category.create!(
    category_group: groups[2],
    name: cat_name
  )
end
['Vacation', 'Long-term', 'Stocks'].map do |cat_name|
  Category.create!(
    category_group: groups[3],
    name: cat_name
  )
end

# ｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆
# 4. Payees
[
  'Starting balance',
  'Amazon',
  'Google',
  'Zara',
  'Wiener Linien',
  'H&M',
  'Kebaps Bros',
  'Burger King',
  'LIBRO',
  'Decus'
].map do |name|
  Payee.create!(
    name: name,
    budget: budget,
  )  
end


# ｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆
# 5. Months
[2.months.ago, 1.month.ago, Date.current].map do |date|
  Month.create!(
    activity: 0,
    budget: budget,
    budgeted: 0,
    income: 0,
    iso_month: IsoMonth.of(date),
    to_be_budgeted: 0,
  )
end