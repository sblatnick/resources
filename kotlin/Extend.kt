

    //Extend Map for functionality like List.partition() for Map.filterKeys()
    fun <K, V> Map<out K, V>.partition(predicate: (K) -> Boolean): Pair<Map<K, V>, Map<K, V>> {
        val result = LinkedHashMap<K, V>()
        val compliment = LinkedHashMap<K, V>()
        for (entry in this) {
            if (predicate(entry.key)) {
                result.put(entry.key, entry.value)
            } else {
                compliment.put(entry.key, entry.value)
            }
        }
        return Pair(result, compliment)
    }

    //Usage:
    val (match, missing) = myMap.partition {  myReferenceMap.containsKey(it) }
