require './binary_tree.rb'
require './expression_parser.rb'

class Combination
    include Enumerable
    
    def initialize(a)
        @arrays = a
        @sizes = []
        a.each{|x| @sizes.push(x.size)}
        @i = Array::new(@arrays.size, 0)
        self
    end
    
    def size
        if @sizes.size == 0 then
            return 0
        else
            return @sizes.inject(1){|x,y| x * y}
        end
    end
    
    def each
        if size == 0 then return nil end
        while @i.last < @sizes.last
            v = []
            @i.each_with_index{|x,y| v.push(@arrays[y][x]) }
            @i[0] += 1
            @i.each_with_index{|x,y|
                if y < @i.size - 1 then
                    while @i[y] >= @sizes[y]
                        @i[y] -= @sizes[y]
                        @i[y+1] += 1
                    end
                end
            }
            yield(v)
        end
    end
end

def each_term(t)
    if t.size == 1 then
        yield('', t)
    else
        it = t.begin_inorder
        ed = t.end_inorder
        while it != ed
            op = ''
            if('+-><='.include?(it.value)) then
                op = it.value
                it.next
            end
            jt = it.clone
            while true
                if jt.node.equal?(t.begin_preorder.node) then break end
                if('+-><='.include?(jt.parent.value) || jt.node.equal?(t.begin_preorder)) then break end
                jt = jt.parent
            end
            yield(op, t.subtree(jt))
            while it != ed
                if('+-><='.include?(it.value)) then break end
                it.next
            end
        end
    end
end

def count_index(t, index, count)
    t.each{|x|
        if(x =~ /([^+^-^>^<^=^_]+)_([^+^-^>^<^=]+)/) then
            a = $2
            a.each_byte{|y|
                c = y.chr
                if index.include?(c) then
                    if count.include?(c) then
                        count[c] += 1
                    else
                        count[c] = 1
                    end
                end
            }
        end
    }
end

def collect_free_index(t, index)
    free_index = []
    each_term(t){|op, term|
        count = {}
        count_index(term, index, count)
        count.each{|key,val|
            if val != 2 && !free_index.include?(key) then
                free_index.push(key)
            end
        }
    }
    return free_index
end

def collect_dummy_index(t, index, free)
    count = {}
    count_index(t, index, count)
    dummy = []
    count.each{|key,val|
        if val == 2 && !free.include?(key) then
            dummy.push(key)
        end
    }
    return dummy
end

def expand_term(sign, tm, index, free)
    dummy = collect_dummy_index(tm, index, free)
    if dummy.size == 0 then
        t = Creek::BinaryTree.new
        t.insert(t.begin_preorder, sign)
        t.append_tree_right(t.begin_preorder, tm.deep_clone)
        return t
    end
    
    di = {}
    da = []
    dummy.each_with_index{|x, i|
        di[x] = i
        da.push(index[x])
    }
    combi = Combination.new(da)
    t = Creek::BinaryTree.new
    combi.each{|d|
        a = tm.deep_clone
        a.each_node{|x|
            if (x.value =~ /([^_]+)_([^+^-^>^<^=]+)/) then
                pre = $1
                post = $2
                dummy.each_with_index{|y,j|
                    post.gsub!(y,d[j].to_s)
                }
                s = ""
                s << pre << '_' << post
                x.value = s
            end
        }
        t.insert(t.begin_preorder, sign)
        t.append_tree_right(t.begin_preorder, a)
    }
    return t
end

def expand_expression(t, index)
    free = collect_free_index(t, index)
    str = ''
    head = true
    result = nil
    each_term(t){|x, term|
        sign = (x != '-') ? '+' : '-'
        if head then
            result = expand_term(sign, term, index, free)
            head = false    
        else
            if '><='.include?(x) then
                right = expand_term(sign, term, index, free)
                result.insert(result.begin_preorder, x)
                result.append_tree_right(result.begin_preorder, right)
            else
                right = expand_term(sign, term, index, free)
                right.append_tree_left(right.begin_inorder, result)
                result = right
            end
        end
    }
    
    if free.size == 0 then
        str = expression_to_str(result)
        return str
    else
        fi = {}
        fa = []
        free.each{|x|
            fa.push(index[x])
            fi[x] = fa.size - 1
        }
        comb = Combination.new(fa)
        str = ""
        comb.each{|v|
            a = result.deep_clone
            a.each_node{|x|
                if (x.value =~ /([^_]+)_([^+^-^>^<^=]+)/) then
                    pre = $1
                    post = $2
                    free.each_with_index{|y,j|
                        post.gsub!(y,v[j].to_s)
                    }
                    s = ""
                    s << pre << '_' << post
                    x.value = s
                end
            }
            str << expression_to_str(a) << "\n"
        }
        return str
    end
end

def expression_to_str(expr)
    str = ''
    be = expr.begin_inorder
    it = expr.begin_inorder
    ed = expr.end_inorder
    while it != ed
        if !(it == be && it.value == '+') then
            if '+-*/><='.include?(it.value) then
                str << ' ' << it.value << ' '
            else
                str << it.value
            end
        end
        if '><='.include?(it.value) then
            it.next
            if it.value == '+' then it.next end
        else
            it.next
        end
    end
    return str
end

parser = ExpressionParser.new
index_notation = {}

while true
    printf('> ');
    STDOUT.flush
    s = STDIN.gets.chomp
    s = s.gsub(/\s/, '')
    if(s == 'q' || s == '') then exit(0) end
    if(/index:([^=]+)=\[([^\]]+)\]/ =~ s) then
        id = $1
        v = $2.split(",")
        index_notation[id] = v
        p index_notation
    else
        tree = parser.parse(s)
        print("#{expand_expression(tree, index_notation)}\n")
    end
end


