//All paths must use \\ or /
const config = {
    update_product: "TOPO_NONGEO",
    release: "May 18",
    database_connection: {
        host: "localhost",
        port: 5432,
        database: "dev",
        user: "postgres",
        password: ""
    },
    TOPO_NONGEO: { 
        source_path: "",
        file_extension: ".gz",
        ogr_format: "/vsigzip/",
        schema_name: "osmm_topo",
        post_processes: ['TOPO_NONGEO_PostProcess_BoundaryLine.sql', 'TOPO_NONGEO_PostProcess_CartographicSymbol.sql', 'TOPO_NONGEO_PostProcess_CartographicText.sql', 'TOPO_NONGEO_PostProcess_TopographicArea.sql', 'TOPO_NONGEO_PostProcess_TopographicLine.sql', 'TOPO_NONGEO_PostProcess_TopographicPoint.sql']
    }    
  };
module.exports = config;
  