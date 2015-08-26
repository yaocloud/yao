module Yao::Resources
  module MetadataAvailable
    def list_metadata(id)
      GET(metadata_path(id)).body["metadata"]
    end

    def create_metadata(id, metadata)
      res = POST(metadata_path(id)) do |req|
        req.body = {"metadata" => metadata}.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      res.body["metadata"]
    end
    alias append_metadata create_metadata

    def update_metadata(id, metadata)
      res = PUT(metadata_path(id)) do |req|
        req.body = {"metadata" => metadata}.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      res.body["metadata"]
    end
    alias replace_metadata update_metadata

    def get_metadata(id, key)
      GET(metadata_key_path(id, key)).body["meta"]
    end

    def set_metadata(id, key, value)
      res = PUT(metadata_key_path(id, key)) do |req|
        req.body = {"meta" => {key => value}}.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      res.body["meta"]
    end

    def delete_metadata(id, key)
      DELETE(metadata_key_path(id, key)).body
    end

    private
    def metadata_path(id)
      ["servers", id, "metadata"].join("/")
    end

    def metadata_key_path(id, key)
      ["servers", id, "metadata", key].join("/")
    end
  end
end
