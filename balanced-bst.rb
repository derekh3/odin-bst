class Node
  attr_accessor :data
  attr_accessor :left
  attr_accessor :right
  def initialize(data=nil, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_accessor :root
  def initialize(arr)
    @array = arr
    @root = build_tree(arr.uniq.sort)
  end

  def build_tree(arr, start = 0, last = arr.length-1)
    
    if start > last
      return
    else
      begin
        mid = (start+last)/2
        root_node = Node.new(arr[mid])
      rescue
        puts start
        puts last
        p arr
      end
      root_node.left = build_tree(arr, start, mid-1)
      root_node.right = build_tree(arr, mid+1, last)
    end
    return root_node
  end

  def insert(key, root=@root)
    if root == nil
      return Node.new(key)
    else
      if key < root.data
        root.left = insert(key, root.left)
      elsif key > root.data
        root.right = insert(key, root.right)
      else
        return root
      end
      return root
    end
  end

  def delete(value, root=@root)
    # When node is a leaf
    if root.left == nil && root.right == nil 
      return root.data == value ? nil : root

    # When node has one child
    elsif root.left == nil && root.right != nil
      if root.data == value
        return root.right
      else
        root.right = delete(value, root.right)
        return root
      end
    elsif root.right == nil && root.left != nil
      if root.data == value
        return root.left
      else
        root.left = delete(value, root.left)
        return root
      end

    # When node has two children
    else
      if value < root.data
        root.left = delete(value, root.left)
      elsif value > root.data
        root.right = delete(value, root.right)
      else
        current_node = root
        current_node = root.right
        while current_node.left != nil
          current_node = current_node.left
        end
        root.data = current_node.data
        root.right = delete(current_node.data, root.right)
      end
      return root
    end
  end

  def find(value, root = @root)
    if value == root.data
      return root
    elsif value < root.data
      return root.left == nil ? nil : find(value, root.left)
    else
      return root.right == nil ? nil : find(value, root.right)
    end
  end

  def level_order
    array = [@root]
    arr_values = []
    while array.length > 0
      if array[array.length-1].left != nil
        array.unshift(array[array.length-1].left)
      end
      if array[array.length-1].right != nil
        array.unshift(array[array.length-1].right)
      end
      new_val = array.pop
      if block_given?
        yield new_val
      else
        arr_values << new_val.data
      end
    end
    if !block_given?
      return arr_values
    end
  end

  def level_order_recursive(array=[], root=@root, &block)
    if block_given?
      block.call(root)
    end

    array << root.left if root.left != nil
    array << root.right if root.right != nil
    return if array.empty?
    level_order_recursive(array, array.shift, &block)
  end

  def inorder(root=@root, arr = [], &block)
    
    if root.left != nil
      arr = inorder(root.left, arr, &block)
    end
    if block_given?
      block.call(root)
    else
      arr << root.data
    end
    if root.right != nil
      arr = inorder(root.right, arr, &block)
    end
    return arr
  end

  def preorder(root=@root, arr = [], &block)
    
    if block_given?
      block.call(root)
    else
      arr << root.data
    end

    if root.left != nil
      arr = preorder(root.left, arr, &block)
    end
    
    if root.right != nil
      arr = preorder(root.right, arr, &block)
    end
    return arr
  end

  def postorder(root=@root, arr = [], &block)
    
    if root.left != nil
      arr = postorder(root.left, arr, &block)
    end
    
    if root.right != nil
      arr = postorder(root.right, arr, &block)
    end

    if block_given?
      block.call(root)
    else
      arr << root.data
    end

    return arr
  end

  def height(node)
    if node == nil
      return 0
    end
    if node.left == nil && node.right == nil
      return 0
    end
    height_left = node.left == nil ? 0 : height(node.left)
    height_right = nil ? 0 : height(node.right)
    height = height_left > height_right ? height_left + 1 : height_right + 1
    return height
  end

  def depth(node)
    arr = []
    arr << @root
    count = 0
    while !arr.include?(node)
      new_arr = []
      arr.each do |n| 
        new_arr << n.left if n.left != nil
        new_arr << n.right if n.right != nil
      end
      arr = new_arr.clone
      count += 1
    end
    return count
  end

  def balanced?(root=@root)
    if root == nil
      return true
    end
    if root.left == nil && root.right == nil
      return true
    end
    left_height = root.left == nil ? 0 : 1 + height(root.left)
    right_height = root.right == nil ? 0 : 1 + height(root.right)
    return (left_height-right_height).abs() <= 1 && balanced?(root.left) && balanced?(root.right)
  end

  def rebalance
    arr = inorder
    @root = build_tree(arr)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

tree= Tree.new([1,2,3,4,5])
tree.pretty_print
puts tree.balanced?
tree.insert(3.5)
tree.pretty_print
puts tree.balanced?
tree.insert(4.5)
tree.pretty_print
puts tree.balanced?
tree.insert(4.25)
tree.pretty_print
puts tree.balanced?

tree.insert(5.5)
tree.insert(4.75)

tree.pretty_print
tree.delete(4)
tree.pretty_print

node = tree.find(2)
puts node.data
puts node

p tree.level_order

p tree.postorder 
puts tree.height(node)

puts tree.depth(node)
puts tree.balanced?

tree.rebalance
tree.pretty_print
puts tree.balanced?

arr_new = (Array.new(15) { rand(1..100) })
tree2 = Tree.new(arr_new)
tree2.pretty_print
puts tree2.balanced?
p tree2.level_order
p tree2.preorder
p tree2.postorder
p tree2.inorder
tree2.insert(101)
tree2.insert(102)
tree2.insert(103)
tree2.pretty_print
puts tree2.balanced?
tree2.rebalance
tree2.pretty_print
puts tree2.balanced?
p tree2.level_order
p tree2.preorder
p tree2.postorder
p tree2.inorder



