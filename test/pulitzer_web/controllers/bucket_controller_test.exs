defmodule PulitzerWeb.BucketControllerTest do
  use PulitzerWeb.ConnCase

  @create_attrs %{identifier: "test_bucket"}
  @invalid_attrs %{identifier: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "renders bucket when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bucket_path(conn, :create), @create_attrs)

      assert %{"identifier" => "test_bucket"} = json_response(conn, 201)
    end

    test "renders errors when identifier is invalid", %{conn: conn} do
      conn = post(conn, Routes.bucket_path(conn, :create), @invalid_attrs)

      assert json_response(conn, 422)["errors"] == %{"identifier" => ["can't be blank"]}
    end

    test "renders errors when identifier is taken", %{conn: conn} do
      Pulitzer.Core.create_bucket("test_bucket")

      conn = post(conn, Routes.bucket_path(conn, :create), @create_attrs)

      assert json_response(conn, 422)["errors"] == %{"identifier" => ["has already been taken"]}
    end
  end
end
