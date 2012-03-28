#------------------------------------------------------------
#    tree
#------------------------------------------------------------

module Creek
    #------------------------------------------------------------
    #    class Node
    #------------------------------------------------------------
    class BinaryNode
        
        def initialize(v = nil, par = nil)
            @value =  v
            @parent = par
            @left = nil
            @right = nil
            return self
        end

        def left_sibling
            if(@parent != nil) then
                if(!@parent.left.equal?(self)) then
                    return @parent.left
                else
                    return nil
                end
            else
                return nil
            end
        end

        def right_sibling
            if(@parent != nil) then
                if(!@parent.right.equal?(self)) then
                    return @parent.right
                else
                    return nil
                end
            else
                return nil
            end
        end

        def preorder_increment
            if(@left != nil) then return @left end
            if(@right != nil) then return @right end
            a = self
            while a != nil
                b = a.right_sibling
                if(b != nil) then
                    return b
                end
                a = a.parent
            end
            return nil
        end
           
        def preorder_decrement
            a = left_sibling
            if(a != nil) then
                while true
                    b = (a.right != nil) ? a.right : a.left
                    if b == nil then return a
                    else a = b
                    end
                end
            end
            if @parent != nil then return @parent end
            return nil
        end

        def inorder_increment
            if(@right != nil) then
                b = @right
                while true
                    c = b.left
                    if c == nil then
                        return b
                    else
                        b = c
                    end
                end
            end
            d = self
            while d.parent != nil
                e = d.parent
                if(e.left.equal?(d)) then
                    return e
                else
                    d = e
                end
            end
            return nil
        end
           
        def inorder_decrement
            if(@left != nil) then
                b = @left
                while true
                    if b.right != nil then
                        b = b.right
                    else
                        return b
                    end
                end
            end
            d = self
            while d != nil
                e = d.parent
                if(e.right.equal?(d)) then
                    return e
                else
                    d = e
                end
            end
            return nil
        end

        def postorder_increment
            if(right_sibling != nil) then
                b = right_sibling
                while true
                    c = (b.left != nil) ? b.left : b.right
                    if(c != nil) then
                        b = c
                    else
                        return b
                    end
                end
            end
            if(@parent != nil) then return @parent end
            return nil
        end
           
        def postorder_decrement
            if(@right != nil) then return @right end
            if(@left != nil) then return @left end
            b = self
            while(b != nil)
                c = b.left_sibling
                if(c != nil) then
                    return c
                else
                    b = b.parent
                end
            end
            return nil
        end

        def set_value(val); @value = val; end
        def set_parent(parent0); @parent = parent0; end
        def set_left(n); @left = n; end
        def set_right(n);@right = n; end
        attr_accessor :value, :parent, :left, :right
    end #---- class Node

    #------------------------------------------------------------
    #    class BinaryTree
    #------------------------------------------------------------
    class BinaryTree
        include Enumerable
        
        def initialize
            @dummy = BinaryNode.new
            @foot = BinaryNode.new(nil, @dummy)
            @root = @foot
            @dummy.left = @root
            @dummy.right = @foot
            @size = 0
            return self
        end
        
        def initialize_copy(other)
            @dummy = BinaryNode.new
            @foot = BinaryNode.new(nil, @dummy)
            @root = @foot
            @dummy.left = @root
            @dummy.right = @foot
            it = other.begin_preorder
            ed = other.end_preorder
            if it != ed then
                @root = BinaryNode.new(it.value, @dummy)
                @dummy.left = @root
            end
            dit = PreorderIterator.new(self, @root)
            while it != ed
                if(it.node.left != nil) then
                    dit.node.left = BinaryNode.new(it.node.left.value, dit.node)
                end
                if(it.node.right != nil) then
                    dit.node.right = BinaryNode.new(it.node.right.value, dit.node)
                end
                it.next
                dit.next
            end
            @size = other.size
            return self
        end
        
        def empty; return (size == 0); end
        
        attr_reader :size
        
        def each
            it = begin_inorder
            ed = end_inorder
            while it != ed
                yield(it.value)
                it.next
            end
        end
        
        def each_node
            it = begin_inorder
            ed = end_inorder
            while it != ed
                yield(it.node)
                it.next
            end
        end
        
        def insert(position, value)
            if empty && position.tree.equal?(self) &&
               position.node.equal?(@root) then
                @root = BinaryNode.new(value, @dummy)
                @dummy.left = @root
                a = position.clone
                a.set_node(@root)
                @size = @size + 1
                return a
            elsif(!empty && position.tree.equal?(self)) then
                n = BinaryNode.new(value, position.node.parent)
                n.left = position.node
                if(n.parent.left.equal?(position.node)) then
                    n.parent.left = n
                elsif(n.parent.right.equal?(position.node)) then
                    n.parent.right = n
                end
                if position.node.equal?(@root) then
                    @root = n
                end
                position.node.parent = n
                a = position.clone
                a.set_node(n)
                @size = @size + 1
                return a
            else
                return nil
            end
        end
        
        def append_child(position, value)
            if empty then
                return nil
            elsif position.node.left == nil then
                return append_child_left(position, value)
            elsif position.node.right == nil then
                return append_child_right(position, value)
            else
                return nil
            end
        end

        def append_child_left(position, value)
            if empty then
                return nil
            elsif position.node.left == nil then
                position.node.left = BinaryNode.new(value, position.node)
                a = position.clone
                a.set_node(position.node.left)
                @size = @size + 1
                return a
            else
                return nil
            end
        end

        def append_child_right(position, value)
            if empty || position.node.equal?(@dummy) ||
               position.node.equal?(@foot) ||
               !position.tree.equal?(self) then
                return nil
            elsif position.node.right == nil then
                position.node.right = BinaryNode.new(value, position.node)
                a = position.clone
                a.set_node(position.node.right)
                @size = @size + 1
                return a
            else
                return nil
            end
        end
        
        def append_tree_left(position, other_tree)
            if(other_tree.equal?(self)) then
                other_tree = self.clone
            end
            if empty || position.node.equal?(@dummy) ||
               position.node.equal?(@foot) ||
               !position.tree.equal?(self) then
                return nil
            elsif position.node.left == nil then
                it = other_tree.begin_preorder
                ed = other_tree.end_preorder
                position.node.left = n = BinaryNode.new(it.value, position.node)
                @size += 1
                dit = PreorderIterator.new(self, n)
                while it != ed
                    if it.node.left != nil
                        append_child_left(dit, it.node.left.value)
                    end
                    if it.node.right != nil
                        append_child_right(dit, it.node.right.value)
                    end
                    it.next
                    dit.next
                end
                self
            else
                return nil
            end
        end

        def append_tree_right(position, other_tree)
            if(other_tree.equal?(self)) then
                other_tree = self.clone
            end
            if empty then
                return nil
            elsif position.node.right == nil then
                it = other_tree.begin_preorder
                ed = other_tree.end_preorder
                position.node.right = n = BinaryNode.new(it.value, position.node)
                @size += 1
                dit = PreorderIterator.new(self, n)
                while it != ed
                    if it.node.left != nil
                        append_child_left(dit, it.node.left.value)
                    end
                    if it.node.right != nil
                        append_child_right(dit, it.node.right.value)
                    end
                    it.next
                    dit.next
                end
                self
            else
                return nil
            end
        end
        
        def count_size
            sz = 0
            it = begin_preorder
            ed = end_preorder
            while it != ed
                sz += 1
                it.next
            end
            return sz
        end
        
        def erase(position)
            if empty then
                return self
            end
            ed = PostorderIterator.new(self, position.node)
            n = position.node
            while n.left != nil || n.right != nil
                n = (n.left != nil) ? n.left : n.right
            end
            it = PostorderIterator.new(self, n)
            while it != ed
                n = it.node
                n.value = nil
                n.left = nil
                n.right = nil
                it.next
                n.parent = nil
            end
            if position.node.equal?(@root) then
                @root.left = nil
                @root.right = nil
                @root.value = nil
                @root.parent = nil
                @dummy.left = nil
                @root = @foot
            else
                par = position.node.parent
                position.node.parent = nil
                position.node.left = nil
                position.node.right = nil
                position.node.value = nil
                if(par.left.equal?(position.node)) then
                    par.left = nil
                elsif(par.right.equal?(position.node)) then
                    par.right = nil
                end
            end
            @size = self.count_size
            return self
        end
        
        def subtree(it)
            if it == nil then return BinaryTree.new end
            t = BinaryTree.new
            t.insert(t.begin_preorder, it.value)
            dit = t.begin_preorder
            
            a = it.node
            while a != nil
                b = a.right_sibling
                if(b != nil) then
                    a = b
                    break
                end
                a = a.parent
            end
            it = PreorderIterator.new(self, it.node)
            ed = PreorderIterator.new(self, a)
            
            while it != ed
                if it.node.left != nil
                    t.append_child_left(dit, it.node.left.value)
                end
                if it.node.right != nil
                    t.append_child_right(dit, it.node.right.value)
                end
                it.next
                dit.next
            end
            return t
        end
        
        def deep_clone
            if empty then return BinaryTree.new end
            it = begin_preorder
            ed = end_preorder
            t = BinaryTree.new
            t.insert(t.begin_preorder, it.value.clone)
            dit = t.begin_preorder
            
            while it != ed
                if it.node.left != nil
                    t.append_child_left(dit, it.node.left.value.clone)
                end
                if it.node.right != nil
                    t.append_child_right(dit, it.node.right.value.clone)
                end
                it.next
                dit.next
            end
            return t
        end
        
        #------------------------------------------------------------
        #    iterator supports
        #------------------------------------------------------------
        def begin_preorder
            PreorderIterator.new(self, @root)
        end

        def end_preorder
            PreorderIterator.new(self, @foot)
        end

        def begin_inorder
            if empty then
                return InorderIterator.new(self, @dummy)
            end
            n = @root
            while n.left != nil
                n = n.left
            end
            InorderIterator.new(self, n)
        end

        def end_inorder
            InorderIterator.new(self, @dummy)
        end

        def begin_postorder
            n = @root
            while (n.left != nil || n.right != nil)
                if(n.left != nil) then
                    n = n.left
                else
                    n = n.right
                end
            end
            return PostorderIterator.new(self, n)
        end

        def end_postorder
            return PostorderIterator.new(self, @foot)
        end
        
        #------------------------------------------------------------
        #    output dot
        #------------------------------------------------------------
        def output_dot(graphname = "G")
            strtmp = String.new
            strtmp << "digraph " << "\"" << graphname << "\" {\n"
            ite1 = self.begin_preorder
            end1 = self.end_preorder
            while(ite1 != end1)
                nodename1 = "N"
                nodename1 << ite1.node.object_id.to_s
                nodename1.gsub!(/-/){"M"}
                strtmp << "\t" << nodename1 << "[ label=\"" << ite1.value.to_s << "\" ];\n"
                if(ite1.node.left != nil) then
                    nodename2 = "N"
                    nodename2 << ite1.node.left.object_id.to_s
                    nodename2.gsub!(/-/){"M"}
                    strtmp << "\t" << nodename1 << " -> " << nodename2 << "\n"
                end
                if(ite1.node.right != nil) then
                    nodename3 = "N"
                    nodename3 << ite1.node.right.object_id.to_s
                    nodename3.gsub!(/-/){"M"}
                    strtmp << "\t" << nodename1 << " -> " << nodename3 << "\n"
                end
                ite1.next
            end
            strtmp << "}\n"
            return strtmp
        end
    end #---- class Tree

    #------------------------------------------------------------
    #    class TreeIteratorBase
    #------------------------------------------------------------
    class TreeIteratorBase
        def initialize(tree, node = nil)
            @tree = tree
            @node = node
            return self
        end
        def initialize_copy(other)
            @tree = other.tree
            @node = other.node
            return self
        end

        def ==(other)
            if(self.class != other.class);
                return false
            else
                return @node.equal?(other.node)
            end
        end

        def set_node(node0)
            @node = node0
        end

        def value
            if(node == nil)
                return nil
            else
                return @node.value
            end
        end

        def set_value(val)
            if(node == nil)
                return nil
            else
                @node.set_value(val)
            end
        end
        
        def parent
            if @node.parent != nil
                jt = self.clone
                jt.set_node(@node.parent)
                return jt
            end
        end
        
        def left
            if @node.left != nil
                jt = self.clone
                jt.set_node(@node.left)
                return jt
            end
        end
        
        def right
            if @node.right != nil
                jt = self.clone
                jt.set_node(@node.right)
                return jt
            end
        end
        
        attr_reader :node, :tree
    end

    #------------------------------------------------------------
    #    class PreorderIterator
    #------------------------------------------------------------
    class PreorderIterator < TreeIteratorBase
        def next
            @node = @node.preorder_increment
            return self
        end

        def prev
            @node = @node.preorder_decrement
            return self
        end
    end #---- class PreorderIterator

    #------------------------------------------------------------
    #    class InorderIterator
    #------------------------------------------------------------
    class InorderIterator < TreeIteratorBase
        def next
            @node = @node.inorder_increment
            return self
        end

        def prev
            @node = @node.inorder_decrement
            return self
        end
    end #---- class InorderIterator
    
    #------------------------------------------------------------
    #    class PostorderIterator
    #------------------------------------------------------------
    class PostorderIterator < TreeIteratorBase
        def next
            @node = @node.postorder_increment
            return self
        end

        def prev
            @node = @node.postorder_decrement
            return self
        end
    end #---- class PostorderIterator
end #---- module Creek


