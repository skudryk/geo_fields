require "rails_helper"

RSpec.describe "Fields", type: :request do
  let(:json_headers) do
    {
      "X-Client-Id"     => ENV.fetch("API_CLIENT_ID", "dev_client_id"),
      "X-Client-Secret" => ENV.fetch("API_CLIENT_SECRET", "dev_client_secret"),
      "Content-Type"    => "application/json",
      "Accept"          => "application/json"
    }
  end

  describe "GET /fields" do
    before { create(:field, name: "North Field") }

    it "returns all fields as JSON" do
      get fields_path, headers: json_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["name"]).to eq("North Field")
    end
  end

  describe "GET /fields/:id" do
    let!(:field) { create(:field, name: "East Field") }

    it "returns the field as JSON" do
      get field_path(field), headers: json_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("East Field")
    end
  end

  describe "POST /fields" do
    let(:payload) do
      {
        field: {
          name: "New Field",
          shape_geo_json: {
            type: "MultiPolygon",
            coordinates: [ [ [ [ 30.0, 50.0 ], [ 30.1, 50.0 ], [ 30.1, 50.1 ], [ 30.0, 50.1 ], [ 30.0, 50.0 ] ] ] ]
          }.to_json
        }
      }.to_json
    end

    it "creates a new field and returns 201" do
      post fields_path, params: payload, headers: json_headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("New Field")
    end
  end

  describe "PATCH /fields/:id" do
    let!(:field) { create(:field) }

    it "updates the field" do
      patch field_path(field),
            params: { field: { name: "Renamed" } }.to_json,
            headers: json_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Renamed")
    end
  end

  describe "DELETE /fields/:id" do
    let!(:field) { create(:field) }

    it "destroys the field" do
      delete field_path(field), headers: json_headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
