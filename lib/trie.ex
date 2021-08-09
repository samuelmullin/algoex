defmodule AlgoEx.Trie do
  alias AlgoEx.TrieNode

  @doc"""
    Accepts a trie and a word.  Inserts the word into the trie if the word does not exist in the trie.  Returns
    the updated trie.
  """
  def add(trie, word) do
    add_node(trie, String.graphemes(word))
  end

  def exists?(%TrieNode{} = node, word) when is_binary(word), do: exists?(node, String.graphemes(word))

  def exists?(%TrieNode{} = node, [letter | []]) do
     case Map.get(node.children, letter) do
        nil -> false
        node -> node.end_of_word == true
     end
  end

  def exists?(%TrieNode{} = node, [letter | tail]) do
    case Map.get(node.children, letter) do
      nil -> false
      node -> exists?(node, tail)
    end
  end


  defp add_node(current_node, [letter | tail]) do
    current_node = case Map.get(current_node.children, letter) do
      nil -> add_child(current_node, letter)
      _node -> current_node
    end

    current_children = current_node.children

    case tail do
      [] ->
        %TrieNode{current_node | children:
          Map.put(current_children, letter, %TrieNode{Map.get(current_children, letter) | end_of_word: true})
        }

      _ ->
        %TrieNode{current_node | children:
          Map.put(current_children, letter, current_children |> Map.get(letter) |> add_node(tail))
        }


    end
  end

  defp add_child(%TrieNode{children: children} = node, value) do
    %TrieNode{node | children: Map.put(children, value, %TrieNode{})}
  end



end
