#############################################
# Represent an individual in the popualtion.
#
#include("./TreeNode.jl")
#include("./InternalNode.jl")
#include("./LeafNode.jl")
#include("../Problem/FunctionSet.jl")
#include("../Problem/TerminalSet.jl")

struct Individual
    root::TreeNode

    Individual(rootNode) = new(rootNode)
end

# Recursively, generate random individual assuming it has a root already
function genRandomIndividual(funcSet::FunctionSet, termSet::TerminalSet, currNode::TreeNode, maxDepth::Int, currDepth::Int)
    # Terminate the recursive calls on leaf nodes since they have no children
    if typeof(currNode) != LeafNode
        # Generate new children for each parameter
        for m in methods(currNode.func)
            numArgs = length(m.sig.parameters)
            for i in 1:(numArgs - 1)
                generated = nothing
                if (currDepth < maxDepth)
                    generated = genRanFuncTerm(funcSet::FunctionSet, termSet::TerminalSet)
                else
                    generated = LeafNode(chooseRand(termSet))
                end
                push!(currNode.children, generated)
            end
        end

        # Recursively call each child
        for nd in currNode.children
            genRandomIndividual(funcSet, termSet, nd, maxDepth, currDepth + 1)
        end
    end
end

# Choose a function or terminal
function genRanFuncTerm(funcSet::FunctionSet, termSet::TerminalSet)
    combined = vcat(funcSet.functions, termSet.terminals)
    num = rand(1:length(combined))
    selected = combined[num]

    if num <= length(funcSet.functions)
        return InternalNode(selected)
    else
        return LeafNode(selected)
    end
end

# Text-based output for an individual
function printIndividual(indiv::Individual)
    visualizeTree(indiv.root, 0)
end
