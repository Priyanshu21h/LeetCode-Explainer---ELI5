class DSTopic {
  final String id;
  final String name;
  final String icon;
  final String difficulty;
  final String description;
  final String code;
  final String language;

  const DSTopic({
    required this.id,
    required this.name,
    required this.icon,
    required this.difficulty,
    required this.description,
    required this.code,
    required this.language,
  });
}

class AlgoTopic {
  final String id;
  final String name;
  final String icon;
  final String difficulty;
  final String category;
  final String description;
  final String code;

  const AlgoTopic({
    required this.id,
    required this.name,
    required this.icon,
    required this.difficulty,
    required this.category,
    required this.description,
    required this.code,
  });
}

final List<DSTopic> dsTopics = [
  DSTopic(
    id: 'array',
    name: 'Array',
    icon: '🗂️',
    difficulty: 'Beginner',
    description: 'Contiguous memory, O(1) access by index.',
    language: 'python',
    code: '''# Array — Two Sum (LeetCode #1)
def twoSum(nums: list[int], target: int) -> list[int]:
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []

# Example
print(twoSum([2, 7, 11, 15], 9))  # [0, 1]
''',
  ),
  DSTopic(
    id: 'stack',
    name: 'Stack',
    icon: '📚',
    difficulty: 'Beginner',
    description: 'LIFO — Last In, First Out structure.',
    language: 'python',
    code: '''# Stack — Valid Parentheses (LeetCode #20)
def isValid(s: str) -> bool:
    stack = []
    mapping = {")": "(", "}": "{", "]": "["}
    for char in s:
        if char in mapping:
            top = stack.pop() if stack else "#"
            if mapping[char] != top:
                return False
        else:
            stack.append(char)
    return not stack

# Example
print(isValid("()[]{}"))  # True
print(isValid("(]"))      # False
''',
  ),
  DSTopic(
    id: 'queue',
    name: 'Queue',
    icon: '🔁',
    difficulty: 'Beginner',
    description: 'FIFO — First In, First Out structure.',
    language: 'python',
    code: '''# Queue — using collections.deque
from collections import deque

class Queue:
    def __init__(self):
        self.q = deque()

    def enqueue(self, val):
        self.q.append(val)

    def dequeue(self):
        if not self.q:
            return None
        return self.q.popleft()

    def peek(self):
        return self.q[0] if self.q else None

    def is_empty(self):
        return len(self.q) == 0

q = Queue()
q.enqueue(1)
q.enqueue(2)
q.enqueue(3)
print(q.dequeue())  # 1
print(q.peek())     # 2
''',
  ),
  DSTopic(
    id: 'linked_list',
    name: 'Linked List',
    icon: '🔗',
    difficulty: 'Intermediate',
    description: 'Nodes linked via pointers. No random access.',
    language: 'python',
    code: '''# Linked List — Reverse a Linked List (LeetCode #206)
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def reverseList(head: ListNode) -> ListNode:
    prev = None
    curr = head
    while curr:
        next_node = curr.next
        curr.next = prev
        prev = curr
        curr = next_node
    return prev

# Build list: 1 -> 2 -> 3 -> 4 -> 5
head = ListNode(1, ListNode(2, ListNode(3, ListNode(4, ListNode(5)))))
result = reverseList(head)
# result: 5 -> 4 -> 3 -> 2 -> 1
''',
  ),
  DSTopic(
    id: 'tree',
    name: 'Binary Tree',
    icon: '🌲',
    difficulty: 'Intermediate',
    description: 'Hierarchical nodes with at most 2 children.',
    language: 'python',
    code: '''# Binary Tree — Inorder Traversal (LeetCode #94)
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def inorderTraversal(root: TreeNode) -> list[int]:
    result = []
    def dfs(node):
        if not node:
            return
        dfs(node.left)
        result.append(node.val)
        dfs(node.right)
    dfs(root)
    return result

# Tree:    1
#           \\
#            2
#           /
#          3
root = TreeNode(1, None, TreeNode(2, TreeNode(3)))
print(inorderTraversal(root))  # [1, 3, 2]
''',
  ),
  DSTopic(
    id: 'graph',
    name: 'Graph',
    icon: '🕸️',
    difficulty: 'Advanced',
    description: 'Nodes (vertices) connected by edges.',
    language: 'python',
    code: '''# Graph — Number of Islands (LeetCode #200)
def numIslands(grid: list[list[str]]) -> int:
    if not grid:
        return 0
    rows, cols = len(grid), len(grid[0])
    count = 0

    def dfs(r, c):
        if r < 0 or r >= rows or c < 0 or c >= cols or grid[r][c] == "0":
            return
        grid[r][c] = "0"  # mark visited
        dfs(r+1, c); dfs(r-1, c)
        dfs(r, c+1); dfs(r, c-1)

    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == "1":
                count += 1
                dfs(r, c)
    return count

grid = [["1","1","0"],["0","1","0"],["0","0","1"]]
print(numIslands(grid))  # 2
''',
  ),
  DSTopic(
    id: 'heap',
    name: 'Heap / Priority Queue',
    icon: '⛰️',
    difficulty: 'Intermediate',
    description: 'Complete binary tree maintaining heap property.',
    language: 'python',
    code: '''# Heap — Kth Largest Element (LeetCode #215)
import heapq

def findKthLargest(nums: list[int], k: int) -> int:
    # Min-heap of size k
    heap = []
    for num in nums:
        heapq.heappush(heap, num)
        if len(heap) > k:
            heapq.heappop(heap)
    return heap[0]

print(findKthLargest([3,2,1,5,6,4], 2))  # 5
print(findKthLargest([3,2,3,1,2,4,5,5,6], 4))  # 4
''',
  ),
  DSTopic(
    id: 'hashmap',
    name: 'Hash Map',
    icon: '🗃️',
    difficulty: 'Beginner',
    description: 'Key-value store with O(1) average lookup.',
    language: 'python',
    code: '''# Hash Map — Group Anagrams (LeetCode #49)
from collections import defaultdict

def groupAnagrams(strs: list[str]) -> list[list[str]]:
    groups = defaultdict(list)
    for s in strs:
        key = tuple(sorted(s))
        groups[key].append(s)
    return list(groups.values())

print(groupAnagrams(["eat","tea","tan","ate","nat","bat"]))
# [["eat","tea","ate"], ["tan","nat"], ["bat"]]
''',
  ),
];

final List<AlgoTopic> algoTopics = [
  AlgoTopic(
    id: 'binary_search',
    name: 'Binary Search',
    icon: '🔍',
    difficulty: 'Beginner',
    category: 'Search',
    description: 'O(log n) search on sorted arrays.',
    code: '''# Binary Search (LeetCode #704)
def search(nums: list[int], target: int) -> int:
    left, right = 0, len(nums) - 1
    while left <= right:
        mid = (left + right) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

print(search([-1,0,3,5,9,12], 9))  # 4
print(search([-1,0,3,5,9,12], 2))  # -1
''',
  ),
  AlgoTopic(
    id: 'bubble_sort',
    name: 'Bubble Sort',
    icon: '🫧',
    difficulty: 'Beginner',
    category: 'Sorting',
    description: 'O(n²) comparison-based sort.',
    code: '''# Bubble Sort
def bubbleSort(arr: list[int]) -> list[int]:
    n = len(arr)
    for i in range(n):
        swapped = False
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swapped = True
        if not swapped:
            break  # Already sorted
    return arr

print(bubbleSort([64, 34, 25, 12, 22, 11, 90]))
# [11, 12, 22, 25, 34, 64, 90]
''',
  ),
  AlgoTopic(
    id: 'merge_sort',
    name: 'Merge Sort',
    icon: '🔀',
    difficulty: 'Intermediate',
    category: 'Sorting',
    description: 'O(n log n) divide-and-conquer sort.',
    code: '''# Merge Sort
def mergeSort(arr: list[int]) -> list[int]:
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = mergeSort(arr[:mid])
    right = mergeSort(arr[mid:])
    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i]); i += 1
        else:
            result.append(right[j]); j += 1
    return result + left[i:] + right[j:]

print(mergeSort([38, 27, 43, 3, 9, 82, 10]))
# [3, 9, 10, 27, 38, 43, 82]
''',
  ),
  AlgoTopic(
    id: 'quick_sort',
    name: 'Quick Sort',
    icon: '⚡',
    difficulty: 'Intermediate',
    category: 'Sorting',
    description: 'O(n log n) avg pivot-based sort.',
    code: '''# Quick Sort
def quickSort(arr: list[int], low=0, high=None) -> list[int]:
    if high is None:
        high = len(arr) - 1
    if low < high:
        pi = partition(arr, low, high)
        quickSort(arr, low, pi - 1)
        quickSort(arr, pi + 1, high)
    return arr

def partition(arr, low, high):
    pivot = arr[high]
    i = low - 1
    for j in range(low, high):
        if arr[j] <= pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
    arr[i+1], arr[high] = arr[high], arr[i+1]
    return i + 1

print(quickSort([10, 7, 8, 9, 1, 5]))
# [1, 5, 7, 8, 9, 10]
''',
  ),
  AlgoTopic(
    id: 'dfs',
    name: 'DFS',
    icon: '🌊',
    difficulty: 'Intermediate',
    category: 'Graph',
    description: 'Depth-First Search — explore deep before wide.',
    code: '''# DFS — Iterative and Recursive
graph = {
    "A": ["B", "C"],
    "B": ["D", "E"],
    "C": ["F"],
    "D": [], "E": [], "F": []
}

def dfs_recursive(node, visited=None):
    if visited is None:
        visited = set()
    visited.add(node)
    print(node, end=" ")
    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs_recursive(neighbor, visited)

def dfs_iterative(start):
    visited = set()
    stack = [start]
    while stack:
        node = stack.pop()
        if node not in visited:
            visited.add(node)
            print(node, end=" ")
            stack.extend(graph[node])

dfs_recursive("A")   # A B D E C F
print()
dfs_iterative("A")   # A C F B E D
''',
  ),
  AlgoTopic(
    id: 'bfs',
    name: 'BFS',
    icon: '🌐',
    difficulty: 'Intermediate',
    category: 'Graph',
    description: 'Breadth-First Search — explore level by level.',
    code: '''# BFS — Level-order traversal
from collections import deque

graph = {
    "A": ["B", "C"],
    "B": ["D", "E"],
    "C": ["F"],
    "D": [], "E": [], "F": []
}

def bfs(start):
    visited = set([start])
    queue = deque([start])
    while queue:
        node = queue.popleft()
        print(node, end=" ")
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

bfs("A")  # A B C D E F
''',
  ),
  AlgoTopic(
    id: 'two_pointers',
    name: 'Two Pointers',
    icon: '👆',
    difficulty: 'Beginner',
    category: 'Technique',
    description: 'Use two indices to reduce O(n²) to O(n).',
    code: '''# Two Pointers — 3Sum (LeetCode #15)
def threeSum(nums: list[int]) -> list[list[int]]:
    nums.sort()
    result = []
    for i in range(len(nums) - 2):
        if i > 0 and nums[i] == nums[i-1]:
            continue
        left, right = i + 1, len(nums) - 1
        while left < right:
            total = nums[i] + nums[left] + nums[right]
            if total == 0:
                result.append([nums[i], nums[left], nums[right]])
                left += 1; right -= 1
                while left < right and nums[left] == nums[left-1]:
                    left += 1
            elif total < 0:
                left += 1
            else:
                right -= 1
    return result

print(threeSum([-1,0,1,2,-1,-4]))  # [[-1,-1,2],[-1,0,1]]
''',
  ),
  AlgoTopic(
    id: 'sliding_window',
    name: 'Sliding Window',
    icon: '🪟',
    difficulty: 'Intermediate',
    category: 'Technique',
    description: 'Dynamic window over array/string.',
    code: '''# Sliding Window — Longest Substring Without Repeating (LC #3)
def lengthOfLongestSubstring(s: str) -> int:
    char_set = set()
    left = 0
    max_len = 0
    for right in range(len(s)):
        while s[right] in char_set:
            char_set.remove(s[left])
            left += 1
        char_set.add(s[right])
        max_len = max(max_len, right - left + 1)
    return max_len

print(lengthOfLongestSubstring("abcabcbb"))  # 3
print(lengthOfLongestSubstring("pwwkew"))    # 3
''',
  ),
  AlgoTopic(
    id: 'dp',
    name: 'Dynamic Programming',
    icon: '🧠',
    difficulty: 'Advanced',
    category: 'Technique',
    description: 'Break problems into overlapping subproblems.',
    code: '''# DP — Longest Common Subsequence (LeetCode #1143)
def longestCommonSubsequence(text1: str, text2: str) -> int:
    m, n = len(text1), len(text2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if text1[i-1] == text2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    return dp[m][n]

print(longestCommonSubsequence("abcde", "ace"))  # 3
print(longestCommonSubsequence("abc", "abc"))    # 3
''',
  ),
  AlgoTopic(
    id: 'dijkstra',
    name: "Dijkstra's",
    icon: '🗺️',
    difficulty: 'Advanced',
    category: 'Graph',
    description: 'Shortest path in weighted graph.',
    code: '''# Dijkstra Shortest Path
import heapq

def dijkstra(graph, start):
    distances = {node: float("inf") for node in graph}
    distances[start] = 0
    heap = [(0, start)]

    while heap:
        dist, node = heapq.heappop(heap)
        if dist > distances[node]:
            continue
        for neighbor, weight in graph[node]:
            new_dist = dist + weight
            if new_dist < distances[neighbor]:
                distances[neighbor] = new_dist
                heapq.heappush(heap, (new_dist, neighbor))
    return distances

graph = {
    "A": [("B", 1), ("C", 4)],
    "B": [("C", 2), ("D", 5)],
    "C": [("D", 1)],
    "D": []
}
print(dijkstra(graph, "A"))
# {"A": 0, "B": 1, "C": 3, "D": 4}
''',
  ),
];
