package models

type PEOPOMapping struct {
	ID           int `json:"id"`
	CurriculumID int `json:"curriculum_id"`
	PEOIndex     int `json:"peo_index"`
	POIndex      int `json:"po_index"`
	MappingValue int `json:"mapping_value"`
}

type PEOPOMappingResponse struct {
	POMatrix    map[string]int `json:"po_matrix"`   // key: "peo_index-po_index"
	PSOPOMatrix map[string]int `json:"psoPoMatrix"` // key: "pso_index-po_index"
}

type PEOPOMappingRequest struct {
	Mappings      []PEOPOMapping `json:"mappings"`
	PSOPOMappings []PSOPOMapping `json:"psoPoMappings"`
}

type PSOPOMapping struct {
	ID           int `json:"id"`
	CurriculumID int `json:"curriculum_id"`
	PSOIndex     int `json:"pso_index"`
	POIndex      int `json:"po_index"`
	MappingValue int `json:"mapping_value"`
}
