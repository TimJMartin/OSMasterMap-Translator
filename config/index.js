//All paths must use \\ or /
const config = {
    update_product: "X",
    release: "X",
    ogr_format: "/vsigzip/",
    file_extension: ".gz",
    database_connection: {
        host: "x",
        port: 5432,
        database: "x",
        user: "x",
        password: "x"
    },
    TOPO_NONGEO: { 
        source_path: "",
        schema_name: "osmm_topo",
        post_processes: ['TOPO_NONGEO_PostProcess_BoundaryLine.sql', 'TOPO_NONGEO_PostProcess_CartographicSymbol.sql', 'TOPO_NONGEO_PostProcess_CartographicText.sql', 'TOPO_NONGEO_PostProcess_TopographicArea.sql', 'TOPO_NONGEO_PostProcess_TopographicLine.sql', 'TOPO_NONGEO_PostProcess_TopographicPoint.sql']
    },
    TOPO_NONGEO_SIMPLE: { 
        source_path: "",
        schema_name: "osmm_topo",
        post_processes: ['TOPO_NONGEO_SIMPLE_PostProcess_BoundaryLine.sql', 'TOPO_NONGEO_SIMPLE_PostProcess_CartographicSymbol.sql', 'TOPO_NONGEO_SIMPLE_PostProcess_CartographicText.sql', 'TOPO_NONGEO_SIMPLE_PostProcess_TopographicArea.sql', 'TOPO_NONGEO_SIMPLE_PostProcess_TopographicLine.sql', 'TOPO_NONGEO_SIMPLE_PostProcess_TopographicPoint.sql']
    }, 
    TOPO_GEO: { 
        source_path: "",
        schema_name: "osmm_topo",
        post_processes: ['TOPO_GEO_PostProcess_BoundaryLine.sql', 'TOPO_GEO_PostProcess_CartographicSymbol.sql', 'TOPO_GEO_PostProcess_CartographicText.sql', 'TOPO_GEO_PostProcess_TopographicArea.sql', 'TOPO_GEO_PostProcess_TopographicLine.sql', 'TOPO_GEO_PostProcess_TopographicPoint.sql']
    },
    TOPO_GEO_COU: { 
        source_path: "",
        schema_name: "osmm_topo_cou",
        update_schema: "osmm_topo",
        post_processes: ['TOPO_GEO_COU_PostProcess_BoundaryLine.sql', 'TOPO_GEO_COU_PostProcess_CartographicSymbol.sql', 'TOPO_GEO_COU_PostProcess_CartographicText.sql', 'TOPO_GEO_COU_PostProcess_TopographicArea.sql', 'TOPO_GEO_COU_PostProcess_TopographicLine.sql', 'TOPO_GEO_COU_PostProcess_TopographicPoint.sql']
    }, 
    TOPO_GEO_SIMPLE: { 
        source_path: "",
        schema_name: "osmm_topo",
        update_schema: "",
        post_processes: ['TOPO_GEO_SIMPLE_PostProcess_BoundaryLine.sql', 'TOPO_GEO_SIMPLE_PostProcess_CartographicSymbol.sql', 'TOPO_GEO_SIMPLE_PostProcess_CartographicText.sql', 'TOPO_GEO_SIMPLE_PostProcess_TopographicArea.sql', 'TOPO_GEO_SIMPLE_PostProcess_TopographicLine.sql', 'TOPO_GEO_SIMPLE_PostProcess_TopographicPoint.sql']
    }    
  };
  export default config