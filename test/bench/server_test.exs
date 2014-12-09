defmodule Bench.ServerTest do
  use ExUnit.Case, async: true


  setup do

    {:ok, serverpid} = Bench.Server.start_link()
    {:ok, server: serverpid}
  end

  test "start_run returns id for stop run", %{server: serverpid} do
    {:ok,ref} = Bench.Server.start_run(serverpid)
    :timer.sleep(100)
    {:ok,elapsed_time} = Bench.Server.stop_run(serverpid,ref)
    assert elapsed_time < 300
    assert elapsed_time > 100
  end

  test "tracks cost per call" , %{server: serverpid} do
    Bench.Server.push_run(serverpid, 2)
    Bench.Server.push_run(serverpid, 3)
    Bench.Server.push_run(serverpid, 4)
    cost = Bench.Server.average_cost_per_call(serverpid)
    assert cost == 3.0
  end

  test "tracks total run clock" , %{server: serverpid} do
    Bench.Server.push_run(serverpid, 2)
    Bench.Server.push_run(serverpid, 3)
    Bench.Server.push_run(serverpid, 4)
    clock = Bench.Server.total_clock(serverpid)
    assert clock == 9
  end


end

