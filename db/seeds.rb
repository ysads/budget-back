puts "Running seeds"

# ｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆
puts "1. Users..."
user = User.create!(
  name: 'Test user',
  email: 'test@mail.com',
  password: '123456'
)

# ｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆
puts "2. Budgets..."
budget = Budget.create!(
  name: 'EUR Budget',
  currency: 'EUR',
  date_format: 'DD.MM.YYYY',
  user: user
)

# ｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆
puts "3. Categories & Category Groups..."
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
puts "4. Payees..."
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
puts "5. Months..."
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

# ｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆｡･:*:･ﾟ★,｡･:*:･ﾟ☆
puts "6. Accounts..."
Account::Checking.create!(
  budget: budget,
  name: 'Erste Bank',
  cleared_balance: 1750_00,
  uncleared_balance: 0
)
Account::Checking.create!(
  budget: budget,
  name: 'N26',
  cleared_balance: 525_00,
  uncleared_balance: 350_00
)
Account::Savings.create!(
  budget: budget,
  name: 'Laptop Pot',
  cleared_balance: 1825_00,
  uncleared_balance: 0
)
Account::Asset.create!(
  budget: budget,
  name: 'Binance',
  cleared_balance: 150_00,
  uncleared_balance: 930_75,
)
