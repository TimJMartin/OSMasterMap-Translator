//All paths must use \\ or /
const config = {
    update_product: "TOPO_GEO_SIMPLE",
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
    },
    TOPO_GEO: { 
        source_path: "",
        file_extension: ".gz",
        ogr_format: "/vsigzip/",
        schema_name: "osmm_topo",
        post_processes: ['TOPO_GEO_PostProcess_BoundaryLine.sql', 'TOPO_GEO_PostProcess_CartographicSymbol.sql', 'TOPO_GEO_PostProcess_CartographicText.sql', 'TOPO_GEO_PostProcess_TopographicArea.sql', 'TOPO_GEO_PostProcess_TopographicLine.sql', 'TOPO_GEO_PostProcess_TopographicPoint.sql']
    },
    TOPO_GEO_SIMPLE: { 
        source_path: "",
        file_extension: ".gz",
        ogr_format: "/vsigzip/",
        schema_name: "osmm_topo",
        post_processes: ['TOPO_GEO_SIMPLE_PostProcess_BoundaryLine.sql', 'TOPO_GEO_SIMPLE_PostProcess_CartographicSymbol.sql', 'TOPO_GEO_SIMPLE_PostProcess_CartographicText.sql', 'TOPO_GEO_SIMPLE_PostProcess_TopographicArea.sql', 'TOPO_GEO_SIMPLE_PostProcess_TopographicLine.sql', 'TOPO_GEO_SIMPLE_PostProcess_TopographicPoint.sql']
    }     
  };
module.exports = config;
  