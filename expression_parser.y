# $Id: expression_parser.y, 2012/03/28 $

class ExpressionParser
    prechigh
        nonassoc UMINUS
        left '*' '/'
        left '+' '-'
        left '>' '<'
        right '='
    preclow
rule
  target: exp
     | /* none */ { result = 0 }

  exp: exp '=' exp
     {
       result.insert(result.begin_preorder, val[1])
       result.append_tree_right(result.begin_preorder, val[2])
       return result
     }
     | exp '>' exp
     {
       result.insert(result.begin_preorder, val[1])
       result.append_tree_right(result.begin_preorder, val[2])
       return result
     }
     | exp '<' exp
     {
       result.insert(result.begin_preorder, val[1])
       result.append_tree_right(result.begin_preorder, val[2])
       return result
     }
     | exp '+' exp
     {
       result.insert(result.begin_preorder, val[1])
       result.append_tree_right(result.begin_preorder, val[2])
       return result
     }
     | exp '-' exp
     {
       result.insert(result.begin_preorder, val[1])
       result.append_tree_right(result.begin_preorder, val[2])
       return result
     }
     | exp '*' exp
     {
       result.insert(result.begin_preorder, val[1])
       result.append_tree_right(result.begin_preorder, val[2])
       return result
     }
     | exp '/' exp
     {
       result.insert(result.begin_preorder, val[1])
       result.append_tree_right(result.begin_preorder, val[2])
       return result
     }
     | '-' VAR = UMINUS
     {
       result = Creek::BinaryTree.new
       result.insert(result.begin_preorder, val[0])
       result.append_child_right(result.begin_preorder, val[1])
       return result
     }
     | VAR
     {
       result = Creek::BinaryTree.new
       result.insert(result.begin_preorder, val[0])
       return result
     }
end

---- header
require './binary_tree'
---- inner
  def parse(str)
    @q = []
    until str.empty?
      case str
      when /\A\w+/
        @q.push [:VAR, $&]
      when /\A.|\n/o
        s = $&
        @q.push [s, s]
      end
      str = $'
    end
    @q.push [false, '$end']
    do_parse
  end

  def next_token
    @q.shift
  end

---- footer


