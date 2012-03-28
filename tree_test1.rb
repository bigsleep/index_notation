#------------------------------------------------------------
#    creek binary tree test01
#------------------------------------------------------------

require './binary_tree'

#---- test_preorder
def test_preorder
  tree0 = Creek::BinaryTree.new
  root = tree0.begin_preorder
  f = tree0.insert(root, "F")
  b = tree0.append_child(f, "B")
  g = tree0.append_child(f, "G")
  a = tree0.append_child(b, "A")
  d = tree0.append_child(b, "D")
  c = tree0.append_child(d, "C")
  e = tree0.append_child(d, "E")
  i = tree0.append_child_right(g, "I")
  h = tree0.append_child_left(i, "H")
  p tree0.size
  
  strtmp = String.new("preorder increment: ")
  ite1 = tree0.begin_preorder
  end1 = tree0.end_preorder
  while(ite1 != end1)
    strtmp << ite1.value.to_s
    ite1.next
  end
  puts strtmp
  
  strtmp = "preorder decrement: "
  ite1 = tree0.end_preorder
  end1 = tree0.begin_preorder
  while(ite1 != end1)
    ite1.prev
    strtmp << ite1.value.to_s
  end
  puts strtmp
  file1 = File.open("tree_test01.dot", 'w')
  file1.puts(tree0.output_dot)
  file1.close
end

#---- test_inorder
def test_inorder
  tree0 = Creek::BinaryTree.new
  root = tree0.begin_preorder
  f = tree0.insert(root, "F")
  b = tree0.append_child(f, "B")
  g = tree0.append_child(f, "G")
  a = tree0.append_child(b, "A")
  d = tree0.append_child(b, "D")
  c = tree0.append_child(d, "C")
  e = tree0.append_child(d, "E")
  i = tree0.append_child_right(g, "I")
  h = tree0.append_child_left(i, "H")
  p tree0.size
  
  strtmp = String.new("inorder increment: ")
  ite1 = tree0.begin_inorder
  end1 = tree0.end_inorder
  while(ite1 != end1)
    strtmp << ite1.value.to_s
    ite1.next
  end
  puts strtmp
  
  strtmp = "inorder decrement: "
  ite1 = tree0.end_inorder
  end1 = tree0.begin_inorder
  while(ite1 != end1)
    ite1.prev
    strtmp << ite1.value.to_s
  end
  puts strtmp
end

#---- test_postorder
def test_postorder
  tree0 = Creek::BinaryTree.new
  root = tree0.begin_preorder
  f = tree0.insert(root, "F")
  b = tree0.append_child(f, "B")
  g = tree0.append_child(f, "G")
  a = tree0.append_child(b, "A")
  d = tree0.append_child(b, "D")
  c = tree0.append_child(d, "C")
  e = tree0.append_child(d, "E")
  i = tree0.append_child_right(g, "I")
  h = tree0.append_child_left(i, "H")
  p tree0.size
  
  strtmp = String.new("postorder increment: ")
  ite1 = tree0.begin_postorder
  end1 = tree0.end_postorder
  while(ite1 != end1)
    strtmp << ite1.value.to_s
    ite1.next
  end
  puts strtmp
  
  strtmp = "postorder decrement: "
  end1 = tree0.begin_postorder
  while(ite1 != end1)
    ite1.prev
    strtmp << ite1.value.to_s
  end
  puts strtmp
end

#---- test_insert
def test_insert
  tree0 = Creek::BinaryTree.new
  root = tree0.begin_preorder
  f = tree0.insert(root, "F")
  b = tree0.append_child(f, "B")
  g = tree0.append_child(f, "G")
  a = tree0.append_child(b, "A")
  d = tree0.append_child(b, "D")
  c = tree0.append_child(d, "C")
  e = tree0.append_child(d, "E")
  i = tree0.append_child_right(g, "I")
  h = tree0.append_child_left(i, "H")
  
  #insert at d
  tree0.insert(d, "J")
  
  strtmp = String.new("insert: ")
  ite1 = tree0.begin_postorder
  end1 = tree0.end_postorder
  while(ite1 != end1)
    strtmp << ite1.value.to_s
    ite1.next
  end
  puts strtmp
  
  strtmp = "insert: "
  end1 = tree0.begin_postorder
  while(ite1 != end1)
    ite1.prev
    strtmp << ite1.value.to_s
  end
  puts strtmp
end

def test_erase
  tree0 = Creek::BinaryTree.new
  root = tree0.begin_preorder
  f = tree0.insert(root, "F")
  b = tree0.append_child(f, "B")
  g = tree0.append_child(f, "G")
  a = tree0.append_child(b, "A")
  d = tree0.append_child(b, "D")
  c = tree0.append_child(d, "C")
  e = tree0.append_child(d, "E")
  i = tree0.append_child_right(g, "I")
  h = tree0.append_child_left(i, "H")
  
  strtmp = String.new("erase at B: ")
  tree0.erase(b)
  ite1 = tree0.begin_preorder
  end1 = tree0.end_preorder
  while(ite1 != end1)
    strtmp << ite1.value.to_s
    ite1.next
  end
  strtmp << " size: " << tree0.size.to_s
  puts strtmp
  
  strtmp = String.new("erase at root:")
  tree0.erase(tree0.begin_preorder)
  ite1 = tree0.begin_preorder
  end1 = tree0.end_preorder
  while(ite1 != end1)
    strtmp << ite1.value.to_s
    ite1.next
  end
  strtmp << " size: " << tree0.size.to_s
  puts strtmp
end

def test_erase
  tree0 = Creek::BinaryTree.new
  root = tree0.begin_preorder
  f = tree0.insert(root, "F")
  b = tree0.append_child(f, "B")
  g = tree0.append_child(f, "G")
  a = tree0.append_child(b, "A")
  d = tree0.append_child(b, "D")
  c = tree0.append_child(d, "C")
  e = tree0.append_child(d, "E")
  i = tree0.append_child_right(g, "I")
  h = tree0.append_child_left(i, "H")
  
  strtmp = String.new("erase at B: ")
  tree0.erase(b)
  ite1 = tree0.begin_preorder
  end1 = tree0.end_preorder
  while(ite1 != end1)
    strtmp << ite1.value.to_s
    ite1.next
  end
  strtmp << " size: " << tree0.size.to_s
  puts strtmp
  
  strtmp = String.new("erase at root:")
  tree0.erase(tree0.begin_preorder)
  ite1 = tree0.begin_preorder
  end1 = tree0.end_preorder
  while(ite1 != end1)
    strtmp << ite1.value.to_s
    ite1.next
  end
  strtmp << " size: " << tree0.size.to_s
  puts strtmp
end

def test_copy
  tree0 = Creek::BinaryTree.new
  root = tree0.begin_preorder
  f = tree0.insert(root, "F")
  b = tree0.append_child(f, "B")
  g = tree0.append_child(f, "G")
  a = tree0.append_child(b, "A")
  d = tree0.append_child(b, "D")
  c = tree0.append_child(d, "C")
  e = tree0.append_child(d, "E")
  i = tree0.append_child_right(g, "I")
  h = tree0.append_child_left(i, "H")
  printf("tree size: %d\n", tree0.size)
  
  cp = tree0.clone
  it = cp.begin_preorder
  ed = cp.end_preorder
  strtmp = String.new("copy:")
  while it != ed
    strtmp << it.value.to_s
    it.next
  end
  strtmp << " size: " << cp.size.to_s
  puts strtmp
  
  tree0.append_tree_right(h, cp)
  strtmp = String.new("append tree:")
  it = tree0.begin_preorder
  ed = tree0.end_preorder
  while it != ed
    strtmp << it.value.to_s
    it.next
  end
  strtmp << " size: " << tree0.size.to_s
  puts strtmp
  
  jt = cp.begin_postorder
  cp.append_tree_right(jt, cp)
  it = cp.begin_preorder
  ed = cp.end_preorder
  strtmp = String.new("append tree self:")
  while it != ed
    strtmp << it.value.to_s
    it.next
  end
  strtmp << " size: " << cp.size.to_s
  puts strtmp
  str = cp.output_dot
  f = File::open("tree1.dot", "w")
  f.print(str)
  f.close
  str = tree0.output_dot
  f = File::open("tree2.dot", "w")
  f.print(str)
  f.close
end

def test_subtree
  tree0 = Creek::BinaryTree.new
  root = tree0.begin_preorder
  f = tree0.insert(root, "F")
  b = tree0.append_child(f, "B")
  g = tree0.append_child(f, "G")
  a = tree0.append_child(b, "A")
  d = tree0.append_child(b, "D")
  c = tree0.append_child(d, "C")
  e = tree0.append_child(d, "E")
  i = tree0.append_child_right(g, "I")
  h = tree0.append_child_left(i, "H")
  printf("tree size: %d\n", tree0.size)
  
  t1 = tree0.subtree(f)
  f = File::open("t1.dot", "w")
  f.print(t1.output_dot)
  p t1.size
  
  t2 = tree0.subtree(b)
  f = File::open("t2.dot", "w")
  f.print(t2.output_dot)
  p t2.size
  
  t3 = tree0.subtree(a)
  f = File::open("t3.dot", "w")
  f.print(t3.output_dot)
  p t3.size
end

def test_deep_clone
  tree0 = Creek::BinaryTree.new
  root = tree0.begin_preorder
  f = tree0.insert(root, "F")
  b = tree0.append_child(f, "B")
  g = tree0.append_child(f, "G")
  a = tree0.append_child(b, "A")
  d = tree0.append_child(b, "D")
  c = tree0.append_child(d, "C")
  e = tree0.append_child(d, "E")
  i = tree0.append_child_right(g, "I")
  h = tree0.append_child_left(i, "H")
  printf("tree size: %d\n", tree0.size)
  
  t1 = tree0.deep_clone
  it1 = tree0.begin_preorder
  end1 = tree0.end_preorder
  it2 = t1.begin_preorder
  end2 = t1.end_preorder
  
  while it1 != end1
    print("#{it1.value} #{it1.value.object_id} : #{it2.value} #{it2.value.object_id}\n")
    it1.next
    it2.next
  end
end

test_preorder
test_inorder
test_postorder
test_insert
test_erase
test_copy
test_subtree
test_deep_clone

