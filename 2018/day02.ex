defmodule Day02 do
  def checksum do
    puzzle = puzzle()
    ids = puzzle |> Enum.map(fn s -> String.graphemes(s) end)
    prop_list = ids |> Enum.map(fn id -> count_list(id) end)
    three_letters = prop_list
                    |> Enum.filter(fn map -> Enum.find(map, fn {_key, value} -> value == 3 end) end)
    two_letters = prop_list
                    |> Enum.filter(fn map -> Enum.find(map, fn {_key, value} -> value == 2 end) end)

    p = length(two_letters)
    q = length(three_letters)
    IO.puts("Star 3: #{p * q}")
  end

  def common_letters do
    puzzle = puzzle()
    map = calculate_distances(puzzle)
    max_jaros = map |> Enum.map(fn {key, value} -> {key, max_jaro(value)} end)
    {first, second, _} = common(max_jaros)
    equal_letters = String.myers_difference(first, second)
    equal_letters = for {:eq, value} <- equal_letters, do: value
    equal_letters = List.foldr(equal_letters, "",fn s, acc -> s <> acc end)
    IO.puts("Star 4: #{equal_letters}")
  end

  defp count_list(id), do: count_list(id, %{})

  defp count_list([], acc), do: acc
  defp count_list([letter | letters], acc) do
    count_list(letters, Map.update(acc, letter, 1, &(&1 + 1)))
  end

  defp calculate_distances(puzzle), do: calculate_distances(puzzle, %{})

  defp calculate_distances([_element], acc), do: acc
  defp calculate_distances([element|elements], acc) do
    distances = jaro(element, elements)
    calculate_distances(elements, Map.put(acc, element, distances))
  end

  defp jaro(element, elements), do: jaro(element, %{}, elements)

  defp jaro(_, acc, []), do: acc
  defp jaro(element, acc, [piece | pieces]) do
    jaro(element, Map.put(acc, piece, String.jaro_distance(element, piece)), pieces)
  end

  defp max_jaro(map) do
    values = Map.values(map)
    map |> Enum.find(fn {_,v} -> v == Enum.max(values) end)
  end

  defp common(map_list), do: common(map_list, {"", "", 0})

  defp common([], best_result), do: best_result
  defp common([{first, {second, jaro}} | results], {_, _, distance}) when jaro > distance do
    common(results, {first, second, jaro})
  end
  defp common([{_, {_, jaro}} | results], {first, second, distance}) when jaro <= distance do
    common(results, {first, second, distance})
  end

  defp puzzle do
    ["ybruvapdgixszyckwtfqjonsie", "mbruvapxghslyyckwtfqjonsie", "mbruvapdghslzyckwtkujonsie", "rwruvapdghxlzyckwtfqjcnsie", "obruvapdgtxlzyckwtfqionsie", "lbruvapdghxqzyckwtfqjfnsie", "mbrunapdghxlzyccatfqjonsie", "mbruvapdghxlzyokltfqjdnsie", "ybruvapdghxlzmckwtfqjmnsie", "mbruwaadghxdzyckwtfqjonsie", "muruvapdghxlzyckvtfqjonsim", "mbruvapdghxlkyckwtxqjonjie", "mbruvaqdghxlzyckwtfqjrnnie", "mwruvapdghdlzyckttfqjonsie", "mbruvapdgtelzyckwxfqjonsie", "mbruvapdohxlzvckwtfqjonhie", "mbrugapdgbxlzyckwtfqjynsie", "mbruvapdghxlzyckwtlqjonjiu", "mbruvapwghxlzyckwafqjonbie", "wbruvapdghxlhyckwtfqjonsii", "mbruvapdghxlzyckwtcqnonsiq", "mbyuvapighxlzybkwtfqjonsie", "mbrrvapdghxvzyckwtfqjonsio", "mhruvapdghrlzyckwtfzjonsie", "mtruvapvghxlzyckwtfnjonsie", "mmrlhapdghxlzyckwtfqjonsie", "mbruvapdgpxlzyjkwtfqjovsie", "mbrucapdghxlzymkwtzqjonsie", "mbeuvafdghxlzyckwtfqjonwie", "mbruvapcghxlayckwtfqjonsii", "mbruvabdghxlzyckwtfqyansie", "mbruvjpdghxlzyckwtfqgfnsie", "lbruvapdghxlzyckwtfqjonriv", "mbrupapdghxlzycjwtfqronsie", "mbpuvapdthxlzymkwtfqjonsie", "mbiuvapdgixlzyckwxfqjonsie", "mbruvapdghxyzyckwtfcjonsbe", "mbrurapkghxlzyckwtfqjonzie", "mbrufapdrhxlzyciwtfqjonsie", "mbruvapdghxlzbckwtfqjoisae", "ubruhapdghxlzuckwtfqjonsie", "mbruvapdjhulzyckwtfqjonshe", "mbruwapdgyxlzyckntfqjonsie", "mwruvapdghplzyckwtfqjonsme", "mbruvapjghtlzyckwtfqgonsie", "pbruvapdghhlzyckwtfrjonsie", "mbruvgpdihxqzyckwtfqjonsie", "mbruvahdohxlzyckwtfijonsie", "ibuuvapdghxlzyckwtfqjofsie", "mbruvandghxlzyckwtfqjrnxie", "mbrjvlpdghxlzyckwgfqjonsie", "mbruvapogfxlzyckotfqjonsie", "mbruvrpdghxlzyckutfejonsie", "mbruvbpdghxlzyhkwtfqjonsip", "mbruvapdghxlzyckmnfqjensie", "mbruvapdghvlzyckwtfqjowsix", "mbruvakdgholzwckwtfqjonsie", "mbruvapdghxlzackwtfqconsae", "mbruvapdghxlzyqvwtfqjlnsie", "mprrvapdgfxlzyckwtfqjonsie", "mbrunacdghxlhyckwtfqjonsie", "obruvapdgsxlzyckwtfqjonvie", "murcvapdghslzyckwtfqjonsie", "mbruvapdghxlzyzkwmftjonsie", "mbrwvapdgtvlzyckwtfqjonsie", "mbxuvapdghxlzqcnwtfqjonsie", "mbruvaddghxboyckwtfqjonsie", "mhruvwndghxlzyckwtfqjonsie", "mbrdvapdghxlzyckwmpqjonsie", "mbruvapdgyxlzyckizfqjonsie", "mbruvapdghxlzlckwtfqeowsie", "mbruvbpdgrxlzyckwtfqjonsxe", "mbruqapoghxlzyckwtvqjonsie", "mbouhapdghmlzyckwtfqjonsie", "mbruvapjghxidyckwtfqjonsie", "mbsuvapkghxlkyckwtfqjonsie", "mbruvlpdghxlzycrwtfqjonsis", "mcrueapdghxlzyckwtfqjynsie", "muruvapngbxlzyckwtfqjonsie", "mbruvapdghxlzycawtfyjojsie", "mbruvbpdghxczyjkwtfqjonsie", "ybduvapdghxnzyckwtfqjonsie", "mbruvbpdghxlzyckwtfbjousie", "mbouvapdghxlzycbwtfqponsie", "mbruvaedghplzycgwtfqjonsie", "mbrhvapdghxlzyckytfqjgnsie", "mbruvapdqbxleyckwtfqjonsie", "mbruvapddhhldyckwtfqjonsie", "mbruvapdghxlwrckwtfqjondie", "mbruvapdmhxlzyckwtfqkonsve", "xbbuvapdghxlzyckwtfkjonsie", "mbruvapdghxlzyckwcfqjunkie", "mbruvapdghxlzyckwtfqxonfib", "mbrtvapkghxlzyckwtfqeonsie", "mbruvazdghxldymkwtfqjonsie", "kbruvapddhxlzfckwtfqjonsie", "mbouvapdghxlpyckwtfqjoosie", "mbauvapdghxlzyckwtfqjszsie", "mbruvapdghtlzyckntfqtonsie", "mbruvipdggxlzbckwtfqjonsie", "mbruqapdghrlzyckwtfqjznsie", "myruvacdghxlzyckwifqjonsie", "mbruvapdghxlzuckwtfkjocsie", "mwjuvapdghxlzyckwtfqjonsxe", "mbruvapxghxlzickwtfqjobsie", "mbrupapdghxtlyckwtfqjonsie", "meruvapdjjxlzyckwtfqjonsie", "mbruvkodghxlzyckwofqjonsie", "mbruvapdgexlzyckwtgkjonsie", "mbruvapwghxlzyckwtcqjonsiw", "mbruvapdghxlzykkwtfqtoxsie", "mbruvapdahxlzycgwtfwjonsie", "mbruvapdgwxlhyckhtfqjonsie", "mbruvapbghxlzycbhmfqjonsie", "mbruvapdghxvzyzkwtfqjonsin", "mbrcvapdqhxlzyckwyfqjonsie", "zbruvaxdghxlzyckwgfqjonsie", "mtruvapdghxlilckwtfqjonsie", "bbruvapdghxlzyckwtfmjonsxe", "mbruvajdghxlzyckwtfqfwnsie", "mbruvapdgkxlzyckwtfqionpie", "rbruvapdghxlryckwdfqjonsie", "mbruvandghxlzyckwmfvjonsie", "mbruvahdghxlzeckwtfqjonsme", "mbruvnpcghxlzyckwtfqjobsie", "mbruvapdghqlzyckwtfbjonsiy", "mbruvavdghxlzyckwufqjodsie", "mbruvapdghxlzyckwtfzmovsie", "mbruvlpdghxuzyckwtfqjoesie", "mbruvopdghxlzycwwtfqjansie", "obruvapdghglzybkwtfqjonsie", "mbpuvlpdghxlcyckwtfqjonsie", "mbruvaidghxlzyckwtfmjonoie", "mbruvapdihxzzyckwtfqjonsiy", "mbquvapdghxlzyckwtfqconsme", "mbruvapdghslzyckqtfqjojsie", "mbrzdapdghxmzyckwtfqjonsie", "mwruvapdghxozyckwtfqjonsxe", "muruvapdgfxlzyckwtfqjojsie", "wtruvapdghxlzyckvtfqjonsie", "mbruvapdghxlzyckysfqjxnsie", "mbruvrpdghxczyckktfqjonsie", "mbquvapdghxlryckwtfqjonsne", "mbruvapdghflzycvwtfqjpnsie", "mbruvapughclzyckwtfqjonsin", "mbrhvapdghxlpyckwtfqjonsre", "mbruvapdgtxlzyckwtfqjoosit", "mbrupapnghxhzyckwtfqjonsie", "mmvuvapdvhxlzyckwtfqjonsie", "mbruvaptghxlzyckwtfqjotsse", "mgruvapvghxlzyckwtfqjonsix", "mbrupapdghxszyckwtfqjunsie", "mbruvkpdghelzyckwtfqjpnsie", "mbruvrrdghjlzyckwtfqjonsie", "mbruvapdghnlzyckwtfkjonsze", "mbruvwpdghxlzyckwtfqhoysie", "mbrsvapdfhxlzyckwtfqjobsie", "mbruvapdgexezymkwtfqjonsie", "ybruvapdghxlzyckwtfqxonsiw", "mrruvapdghxdzyckwtfqjossie", "mbruvapdghtlzyckwtfqconsiu", "mbrpvapdghxlzlckwpfqjonsie", "mbruvjpdghslzyckwtfqjjnsie", "mhruvapoghxlzyckwtfvjonsie", "mbrubqpdghvlzyckwtfqjonsie", "mbruvapdghxlzackwtfqconsiw", "mbruvapdgnxlzkckwtfqjdnsie", "mbrudapgghelzyckwtfqjonsie", "mbruvapdghxlzlakwbfqjonsie", "mbpuvapdghxlzyckwtuqjonjie", "abruvapdghxlzykkwtfqjonzie", "mbrupupdghxlsyckwtfqjonsie", "mbrsvupdghxlzyckwtfqjonkie", "mxruvgpdghxllyckwtfqjonsie", "mbrnvapdghxlzycbwtfqfonsie", "mbrbxapdghxlzyckttfqjonsie", "mbnuvapdghxlzyxkwtmqjonsie", "mbrfvapdghjlzickwtfqjonsie", "mbhuvupdghxlzyxkwtfqjonsie", "mbrcvapdghxluyckwtfqjznsie", "mbruvapdghxlzyckwofqjoxsiz", "mbrevapdghxloyckwtfqjonnie", "mbruvipdghnlzyckwtfqjopsie", "mbxxvaptghxlzyckwtfqjonsie", "mbruvcpdghxlztckwtjqjonsie", "mqruvlpdghxlzyckotfqjonsie", "mbruvapdgqxlzyckwtfqjpvsie", "mbruvapdgvxlzyjkwtfqjbnsie", "mbruvapdghxlgyckwtfqcocsie", "mbruvapdghxkwyckwtfqjoqsie", "mbrgvavdghxlzyckwxfqjonsie", "qbruqapdgvxlzyckwtfqjonsie", "mbauvapdghxlzgckwtfqjunsie", "mbruvapdgdxluyckwtfqjoosie", "mbruvapdghxlzykkwtfqwobsie", "mbruvapdghxlzhcnwtfqjonqie", "mbruvapdghxlzycbhmfqjonsie", "mbruvapdghxluyczwtfqjontie", "mbruvapnghxlzyckwnfqjonbie", "moruvapdghxlzcckwtfqponsie", "mbruvapfgxxlzyckwtfqjunsie", "mbruvapdghxlryckvtfejonsie", "mbrzvapdghxlzvcbwtfqjonsie", "mbruvapdgqxlzyckwcfqjonsce", "abruvupdrhxlzyckwtfqjonsie", "mbrubaptghxlzyckwtfqjondie", "mgruvapdgpxlzyckwtfijonsie", "mbruvapdghxczlckwtfujonsie", "mbruvapdgmmlzyckwtfqjonsir", "mbruvapdhhxltyckwtfdjonsie", "mbruvapdghxlzyckwtfdjjnste", "mbrdvzpdghxlcyckwtfqjonsie", "mbruvapdghxlzyckwtnqbonsim", "mbrovapdghxlzyckwtfpjousie", "mymuvapdghxlzyjkwtfqjonsie", "mbpuvapdghxlzyckwtfljcnsie", "mbrxvapdghxlzyclwtfqjonpie", "mbrueapdghxlzyckwtfqjopsia", "mbruvapdghxlzycdwtfqjbfsie", "tbruvavdghxlzyckwtmqjonsie", "mbduvapdghxlzyckwrfqjrnsie", "mkrsvapughxlzyckwtfqjonsie", "mbruvapdghylzyckwtfqtolsie", "mgruvapdglxldyckwtfqjonsie", "mbrunapdghclzyckwtfqjonsiy", "mbruvapdgrxlxyckwtfgjonsie", "mbruvapdghxpzbckftfqjonsie", "mbruvcpdghxyzyckotfqjonsie", "mbruvapdghxlsyckwtfqcqnsie", "mbruvapdghxlzzckwtfqjonskf", "mbruvppdghxlzfckwtfqjgnsie", "mbhuvapdghxlzytkwtfqjonoie", "mbruvapdghxlzvrkwtfqjjnsie", "mbmuvapdghxuzyckwtfqjonsze", "mbruvapdghnlzycnwtfqjonsil", "mbruvapdgholzyckitfqjonsia", "mbruxapdghxlmyckwtfqbonsie", "mbauvapdgholzyckwtfqjolsie", "mbruvapdghxlzyckwtfqjotslq", "dbrutapdghxlzyckwtfqjonsiv", "mbruvapdzhxlyyckwtfbjonsie", "mmruaapsghxlzyckwtfqjonsie", "mbruvaldgqxqzyckwtfqjonsie", "mbruvaodghxdzyjkwtfqjonsie", "mbrcmatdghxlzyckwtfqjonsie", "mbrqvapdgtxlzycewtfqjonsie", "mjruvapdghzlzyckwtfqjonrie", "mbruvapdghxopcckwtfqjonsie", "mbruvapdghxszycwwtfqjoqsie", "mbruvapdgoxezyckwtjqjonsie"]
  end
end