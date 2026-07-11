namespace Parser.DXBC.IR;

// Mirrors D3D10_SB_INTERPOLATION_MODE. In real DXBC this is encoded in bits
// of the dcl_input_ps opcode token itself (NOT a separate trailing DWORD the
// way dcl_input_sgv/dcl_output_siv are). ShdrParser does not currently
// extract these bits — verify the bit offset against shader_sm4.c
// (d3d_sm4_get_interpolation_mode / similar) before wiring up the decode;
// the enum and declaration field are provided so that decode is a one-line
// change once confirmed, rather than a schema change.
public enum InterpolationMode
{
    Undefined = 0,
    Constant = 1,
    Linear = 2,
    LinearCentroid = 3,
    LinearNoPerspective = 4,
    LinearNoPerspectiveCentroid = 5,
    LinearSample = 6,
    LinearNoPerspectiveSample = 7,
}