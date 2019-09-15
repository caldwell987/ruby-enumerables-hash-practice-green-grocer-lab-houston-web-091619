def consolidate_cart(cart)
  new_cart = {}
  cart.each do |hash| #hash is the whole array
    hash.each do |name, describe| #name: avocado, cheese. describe: price, clearance
      #if new_cart has name and count already, increase the count
      if new_cart[name]
        new_cart[name][:count] += 1
      #new_cart is empty so set name as key and describe as value
      else
        new_cart[name] = describe
        new_cart[name][:count] = 1 #set count = 1 cuz we set name and describe for 1 item
      end
    end
  end
  new_cart
end

# apply coupon to the cart,
# adds a new key, value pair to the cart hash called 'ITEM NAME W/COUPON'
# adds the coupon price to the property hash of couponed item
# adds the count number to the property hash of couponed item
# removes the number of discounted items from the original item's count
# remembers if the item was on clearance
# accounts for when there are more items than the coupon allows
# doesn't break if the coupon doesn't apply to any items

def apply_coupons(cart, coupons)
  #doesn't break if there is no coupon
  return cart if coupons == []

  #set new_cart = cart so we don't have to push all the values, just change them
  new_cart = cart

  coupons.each do |coupon|
    name = coupon[:item] #avocado, cheese,...
    num_of_c = coupon[:num]
    #if the cart has the same item in coupon and has larger amount than in coupon
    if cart.include?(name) && cart[name][:count] >= num_of_c
       #remove number of the new_cart's count
       new_cart[name][:count] -= num_of_c
       #increase the count when there is more items than the coupon allows
       if new_cart["#{name} W/COUPON"]
         new_cart["#{name} W/COUPON"][:count] += 1
       #set the name with coupon with new value
       else
         new_cart["#{name} W/COUPON"] = {
           :price => coupon[:cost],
           :clearance => new_cart[name][:clearance],
           :count => 1
         }
       end
     end
   end
   new_cart
end

#result:
{
  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 1},
  "KALE"    => {:price => 3.0, :clearance => false, :count => 1},
  "AVOCADO W/COUPON" => {:price => 5.0, :clearance => true, :count => 1},
}

# apply clearance:
# takes 20% off price if the item is on clearance
# does not discount the price for items not on clearance

def apply_clearance(cart)
  new_cart = cart
  cart.each do |name, hash|
      if hash[:clearance] #if clearance is true, take 20% off
        new_cart[name][:price] = (cart[name][:price] * 0.8).round(2)
      end
  end
  new_cart #if not, just return the same cart
end

# checkout:
# Apply coupon discounts if the proper number of items are present.# calls on #apply_clearance after calling on #apply_coupons when there is only one item in the cart and no coupon
# Apply 20% discount if items are on clearance.
# If, after applying the coupon discounts and the clearance discounts, the cart's total is over $100, then apply a 10% discount.

def checkout(cart, coupons)
  #call the consolidate to get the count item first
  new_cart = consolidate_cart(cart)
  #apply coupon to the new cart
  apply_coupons(new_cart, coupons)
  #apply clearance after discount from coupon
  apply_clearance(new_cart)

total = 0
  new_cart.each do |name, hash|
    total += (hash[:price] * hash[:count])
  end

if total >= 100
    total *= 0.9
  end

  total
end