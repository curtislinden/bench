defmodule Bench.Server do
  require Logger
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__,:ok,opts)
  end

  def init(:ok) do
    state = HashDict.new
    state = HashDict.put(state,:count, 0)
    state = HashDict.put(state,:runs, [])
    {:ok, state }
  end
  
  def total_clock(server) do
    GenServer.call(server,{:total_clock})
  end

  def push_run(server,run) do
    GenServer.cast(server,{:push_run, run})
  end

  def start_run(server) do
    GenServer.call(server, {:start_run})
  end
  
  def stop_run(server,ref) do
    GenServer.call(server, {:stop_run , ref})
  end

  def average_cost_per_call(server) do
    GenServer.call(server,{:avg_cost_per_call})
  end

  def handle_call({:total_clock}, _from, state ) do
    {:reply, Enum.sum(HashDict.get(state,:runs)), state}
  end

  def handle_call({:avg_cost_per_call},_from, state ) do
    {:reply, (Enum.sum(HashDict.get(state,:runs)) / HashDict.get(state,:count)) , state}
  end

  def handle_call({:start_run}, _from, state) do
    ref = UUID.uuid4()
    HashDict.put(state,
    {:reply, {:ok, "1"} , state}
  end

  def handle_call({:stop_run, ref}, _from, state) do
    {:reply, {:ok, 100} , state}
  end

  def handle_cast({:push_run, run},state) do
    state = HashDict.put(state,:runs, [run|HashDict.get(state,:runs)])
    state = HashDict.put(state,:count ,HashDict.get(state,:count) + 1)
    {:noreply, state}
  end
end
