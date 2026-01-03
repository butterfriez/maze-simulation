--!strict
--!native
--!optimize 2

type Element<ValueType> = {
	value: ValueType,
	priority: number,
}

export type PriorityQueue<ValueType> = {
	_items: { Element<ValueType> },
	Enqueue: (self: PriorityQueue<ValueType>, item: ValueType, priority: number) -> (),
	Dequeue: (self: PriorityQueue<ValueType>) -> "Underflow" | ValueType,
	Front: (self: PriorityQueue<ValueType>) -> "No elements in queue" | ValueType,
	Rear: (self: PriorityQueue<ValueType>) -> "No elements in queue" | ValueType,
	Size: (self: PriorityQueue<ValueType>) -> number,
}

type PriorityQueueClass = {
	new: <ValueType>() -> PriorityQueue<ValueType>,
}

local PriorityQueue = {}
local PriorityQueueClass = { metatable = { __index = PriorityQueue } } :: any

function PriorityQueueClass.new<ValueType>()
	local self: PriorityQueue<ValueType> = setmetatable({}, PriorityQueueClass.metatable) :: any

	self._items = {}

	return self
end

function PriorityQueue.Enqueue<ValueType>(self: PriorityQueue<ValueType>, item: ValueType, priority: number)
	local element: Element<ValueType> = {
		value = item,
		priority = priority,
	}

	local contain = false

	for i = 1, #self._items do
		if self._items[i].priority > element.priority then
			table.remove(self._items, i)
			self._items[i] = element

			contain = true
			break
		end
	end

	if contain == false then
		table.insert(self._items, element)
	end
end

function PriorityQueue.Dequeue<ValueType>(self: PriorityQueue<ValueType>): "Underflow" | ValueType
	if #self._items > 0 then
		local element = table.remove(self._items, 1) :: Element<ValueType>

		return element.value
	end

	return "Underflow"
end

function PriorityQueue.Front<ValueType>(self: PriorityQueue<ValueType>): "No elements in queue" | ValueType
	if #self._items == 0 then
		return "No elements in queue"
	end

	return self._items[1].value
end

function PriorityQueue.Rear<ValueType>(self: PriorityQueue<ValueType>): "No elements in queue" | ValueType
	if #self._items == 0 then
		return "No elements in queue"
	end

	return self._items[#self._items].value
end

function PriorityQueue.Size(self: PriorityQueue<unknown>): number
	return #self._items
end

return PriorityQueueClass :: PriorityQueueClass
