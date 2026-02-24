import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    mode:    String,
    geojson: String,
    fields:  String,
    inputId: String
  }

  connect() {
    this.map = L.map(this.element).setView([50.0, 30.0], 6)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors"
    }).addTo(this.map)

    switch (this.modeValue) {
      case "index": this._loadIndex(); break
      case "show":  this._loadShow();  break
      case "draw":  this._loadDraw();  break
    }
  }

  disconnect() {
    if (this.map) this.map.remove()
  }

  _loadIndex() {
    if (!this.hasFieldsValue) return
    const fields = JSON.parse(this.fieldsValue)
    const layers = []

    fields.forEach(field => {
      if (!field.geojson) return
      const layer = L.geoJSON(field.geojson, {
        style: { color: "#2d6a4f", weight: 2, fillOpacity: 0.3 }
      })
      layer.bindPopup(`<strong>${field.name}</strong>`)
      layer.addTo(this.map)
      layers.push(layer)
    })

    if (layers.length > 0) {
      const group = L.featureGroup(layers)
      this.map.fitBounds(group.getBounds().pad(0.1))
    }
  }

  _loadShow() {
    if (!this.hasGeojsonValue || !this.geojsonValue) return
    const geojson = JSON.parse(this.geojsonValue)
    const layer = L.geoJSON(geojson, {
      style: { color: "#1b4332", weight: 3, fillOpacity: 0.35 }
    }).addTo(this.map)
    this.map.fitBounds(layer.getBounds().pad(0.15))
  }

  // draw/edit  Geo polygon drawing with vertex editing
  _loadDraw() {
    this.drawnItems = new L.FeatureGroup()
    this.map.addLayer(this.drawnItems)

    // Pre-load existing shape as native L.polygon instances
    if (this.hasGeojsonValue && this.geojsonValue) {
      try {
        const geojson = JSON.parse(this.geojsonValue)

        // Normalise MultiPolygon / Polygon → array of polygon coordinate sets
        const polygonCoordSets = geojson.type === "MultiPolygon"
          ? geojson.coordinates
          : [geojson.coordinates]

        polygonCoordSets.forEach(rings => {
          // GeoJSON coords are [lng, lat]; Leaflet expects [lat, lng]
          const latlngs = rings.map(ring => ring.map(([lng, lat]) => [lat, lng]))
          this.drawnItems.addLayer(L.polygon(latlngs))
        })

        if (this.drawnItems.getLayers().length > 0) {
          this.map.fitBounds(this.drawnItems.getBounds().pad(0.15))
        }
      } catch (_) { /* new field – no pre-existing shape */ }
    }

    const drawControl = new L.Control.Draw({
      edit: false,
      draw: {
        polygon:      true,
        polyline:     false,
        rectangle:    false,
        circle:       false,
        marker:       false,
        circlemarker: false
      }
    })
    this.map.addControl(drawControl)

    this._enableEditing()

    this.map.on(L.Draw.Event.CREATED, e => {
      this._disableEditing()
      this.drawnItems.clearLayers()
      this.drawnItems.addLayer(e.layer)
      this._enableEditing()
      this._syncInput()
    })

    // Sync hidden input right before the form is submitted so any
    // vertex drags (done via layer.editing) are captured.
    const form = document.querySelector("form")
    if (form) {
      form.addEventListener("submit", () => this._syncInput(), { capture: true })
    }
  }

  // Enable Leaflet.draw vertex editing on every polygon in drawnItems.
  _enableEditing() {
    this.drawnItems.getLayers().forEach(layer => {
      if (layer.editing) layer.editing.enable()
    })
  }

  _disableEditing() {
    this.drawnItems.getLayers().forEach(layer => {
      if (layer.editing) layer.editing.disable()
    })
  }

  // Serialise all drawn layers → MultiPolygon GeoJSON → hidden form input
  _syncInput() {
    const input = document.getElementById(this.inputIdValue)
    if (!input) return

    const layers = this.drawnItems.getLayers()
    if (layers.length === 0) { input.value = ""; return }

    // layer.toGeoJSON().geometry.coordinates = Polygon rings [[lng,lat],...]
    const coordinates = layers.map(layer => layer.toGeoJSON().geometry.coordinates)
    input.value = JSON.stringify({ type: "MultiPolygon", coordinates })
  }
}
