#{encoding: utf-8}
def inputs
  ['ITEM000001','ITEM000001','ITEM000001','ITEM000001','ITEM000001', 'ITEM000003-2','ITEM000005','ITEM000005', 'ITEM000005']
end
def loadPromotions
  ['ITEM000000','ITEM000001','ITEM000005']
end
def allItems
  [{
       :barcode=>'ITEM000000',
       :name=>'可口可乐',
       :unit=> '瓶',
       :price=> 3.00
   },
   {
       :barcode=> 'ITEM000001',
       :name=> '雪碧',
       :unit=> '瓶',
       :price=> 3.00
   },
   {
       :barcode=> 'ITEM000002',
       :name=> '苹果',
       :unit=> '斤',
       :price=> 5.50
   },
   {
       :barcode=> 'ITEM000003',
       :name=> '荔枝',
       :unit=> '斤',
       :price=> 15.00
   },
   {
       :barcode=> 'ITEM000004',
       :name=> '电池',
       :unit=> '个',
       :price=> 2.00
   },
   {
       :barcode=> 'ITEM000005',
       :name=> '方便面',
       :unit=> '袋',
       :price=> 4.50
   }]
end
class MyPosJi
  def getNewInput(array)
    newInput = array
    counter = Hash.new(0)
    newInput.each { |val| counter[val]+=1 }
    return counter

  end
  def getBuyList(inputParameters)
    listCustomer = inputParameters
    listStore = allItems
    customerBuyList = Array.new
    listCustomer.each do |key,value|
      listStore.each do |lS|
        if key == lS[:barcode]
          lS[:count] = value
          lS[:freeCount] = 0
          customerBuyList.push(lS)
        end
        if key != lS[:barcode] && key[0,key.index('-').to_i] == lS[:barcode]
          lS[:count] = key[key.index('-').to_i + 1,key.size].to_i
          lS[:freeCount] = 0
          customerBuyList.push(lS)
        end
      end
    end
    return customerBuyList
  end
  def getForFreeList(inputsParameters)
    storeFreeList = loadPromotions
    buyList = inputsParameters
    customerBuyFreeList = Array.new
    buyList.each do |bL|
      storeFreeList.each do |sFL|
        if bL[:barcode] == sFL
          bL[:freeCount] += (bL[:count]/3).floor
          customerBuyFreeList.push(bL)
        end
      end
    end
    return customerBuyFreeList
  end
  def showShoppingList(printBuylist,printFreeList)
    paySumNum = 0
    freeSumNum = 0
    showBuy = printBuylist
    showFree = printFreeList
    str = "***<没钱赚商店>购物清单***\n"
    showBuy.map do |item1|
      str += "名称:" + item1[:name] + ",数量:" + item1[:count].to_s + item1[:unit] + ",单价:" + "%0.2f" % item1[:price].to_s + "(元),小计:" + "%0.2f" % ((item1[:count] - item1[:freeCount]) * item1[:price]).to_s + "(元)" + "\n"
      paySumNum += (item1[:count] - item1[:freeCount]) * item1[:price]
    end
    str += "----------------------" + "\n" +"挥泪赠送商品：" + "\n"
    showFree.map do |item2|
      str += "名称:" + item2[:name] + ",数量:" + item2[:freeCount].to_s + item2[:unit] + "\n"
      freeSumNum += item2[:freeCount] * item2[:price]
    end
    str += "----------------------" + "\n" + "总计：" + "%0.2f" % paySumNum.to_s + "（元）" + "\n" + "节省：" + "%0.2f" % freeSumNum.to_s + "(元)" + "\n" + "**********************"
    puts str
    return str
  end
end
myposji = MyPosJi.new
newInputs = myposji.getNewInput(inputs)
buyList = myposji.getBuyList(newInputs)
freeList = myposji.getForFreeList(buyList)
myposji.showShoppingList(buyList,freeList)













