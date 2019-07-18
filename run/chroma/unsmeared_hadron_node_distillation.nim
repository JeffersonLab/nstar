## Prop and matelem distillation

import propagator, link_smearing
import serializetools/serializexml
import xmltree
import inline_meas

# io/xml_group_reader


#------------------------------------------------------------------------------
type
  ## Parameters
  DispGammaMom_t* = object
    gamma*:           cint        ## The gamma matrix for this displacement
    displacement*:    seq[cint]   ## The displacement path for this gamma
    mom*:             array[0..2,cint]  ## Array of momenta to generate 

  KeySolnProp_t* = object
    cacheP*:          bool
    num_vecs*:        int         ## Number of color vectors to use
    t_source*:        int         ## Time slice source for props
    Nt_forward*:      int         ## Forward
    Nt_backward*:     int         ## Backward

  SinkSource_t* = object
    t_sink*:          int         ## Time slice for sinks
    t_source*:        int         ## Time slice source for props
    Nt_backward*:     int         ## Backward relative to source
    Nt_forward*:      int         ## Forward relative to source

  Contract_t* = object
    use_derivP*:      bool        ## Use derivatives
    decay_dir*:       int         ## Decay direction
    displacement_length*: int     ## Displacement length for insertions
    mass_label*:      string      ## Some kind of mass label
    num_tries*:       int         ## In case of bad things happening in the solution vectors, do retries

  NamedObject_t* = object
    gauge_id*:        string      ## !< Gauge field
    colorvec_files*:  seq[string] ## !< Eigenvectors in mod format
    dist_op_file*:    string      ## !< File name for propagator matrix elements
    
  DistParams_t* = object
    LinkSmearing*:         XmlNode             ## !< link smearing xml
    PropSources*:          seq[KeySolnProp_t]  ## !< Sources
    SinkSourcePairs*:      seq[SinkSource_t]   ## !< Combos
    DispGammaMomList*:     seq[DispGammaMom_t] ## !< Array of displacements, gammas, and moms to generate
    Propagator*:           Propagator_t        ## !< Propagator input
    Contractions*:         Contract_t          ## !< Backward propagator and contraction pieces

  UnsmearedMesonNodeDistillationParams_t* = object
    Name*:            string
    Frequency*:       int
    Param*:           DistParams_t
    NamedObject*:     NamedObject_t



proc newUnsmearedMesonNodeDistParams*(link: XmlNode,
                                      props: seq[KeySolnProp_t],
                                      sink: seq[SinkSource_t],
                                      disp: seq[DispGammaMom_t],
                                      prop: Propagator_t,
                                      contract: Contract_t): DistParams_t =
  ## Return a new unsmeared meson node param struct
  return DistParams_t(LinkSmearing: link,
                      PropSources: props,
                      SinkSourcePairs: sink,
                      DispGammaMomList: disp,
                      Propagator: prop,
                      Contractions: contract)


proc newUnsmearedMesonNodeDistillation*(Param: DistParams_t, NamedObject: NamedObject_t): XmlNode =
  ## Return a new unsmeared meson node
  return serializeXML(UnsmearedMesonNodeDistillationParams_t(Name: "UNSMEARED_HADRON_NODE_DISTILLATION", 
                                                             Frequency: 1, 
                                                             Param: Param, 
                                                             NamedObject: NamedObject))


#------------------------------------------------------------------------------
when isMainModule:
  let link = newStoutLinkSmearing(0.1, 10, 3)
  echo "xml= ", $link



#[
#------------------------------------------------------------------------------
<?xml version="1.0"?>
<chroma>
<Param> 
  <InlineMeasurements>

    <elem>
      <Name>UNSMEARED_HADRON_NODE_DISTILLATION</Name>
      <Frequency>1</Frequency>
      <Param>
        <!-- List of displacement arrays -->
        <DispGammaMomList>
          <elem>
            <displacement></displacement>
            <gamma>0</gamma>
            <mom>0 0 0</mom>
	  </elem>
          <elem>
            <displacement></displacement>
            <gamma>1</gamma>
            <mom>0 0 0</mom>
	  </elem>

        </DispGammaMomList>

        <LinkSmearing>
          <LinkSmearingType>NONE</LinkSmearingType>
          <!-- LinkSmearingType>STOUT_SMEAR</LinkSmearingType -->
          <link_smear_fact>0.1625</link_smear_fact>
          <link_smear_num>4</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

        <PropSources>
	  <elem>
            <cacheP>true</cacheP>
            <num_vecs>10</num_vecs>
            <t_source>0</t_source>
            <Nt_forward>16</Nt_forward>
            <Nt_backward>0</Nt_backward>
	  </elem>
	  <elem>
            <cacheP>true</cacheP>
            <num_vecs>10</num_vecs>
            <t_source>6</t_source>
            <Nt_forward>0</Nt_forward>
            <Nt_backward>16</Nt_backward>
	  </elem>
        </PropSources>

        <SinkSourcePairs>
	  <elem>
            <t_sink>6</t_sink>
            <t_source>0</t_source>
            <Nt_forward>16</Nt_forward>
            <Nt_backward>0</Nt_backward>
	  </elem>
	  <elem>
            <t_sink>0</t_sink>
            <t_source>0</t_source>
            <Nt_forward>16</Nt_forward>
            <Nt_backward>0</Nt_backward>
	  </elem>
	  <elem>
            <t_sink>6</t_sink>
            <t_source>6</t_source>
            <Nt_forward>0</Nt_forward>
            <Nt_backward>16</Nt_backward>
	  </elem>
        </SinkSourcePairs>

        <Contractions>
          <use_derivP>false</use_derivP>
          <mass_label>U0.05</mass_label>
          <decay_dir>3</decay_dir>
          <displacement_length>1</displacement_length>
          <num_tries>0</num_tries>
        </Contractions>

        <Propagator>
          <version>10</version>
          <quarkSpinType>FULL</quarkSpinType>
          <obsvP>false</obsvP>
          <numRetries>1</numRetries>
          <FermionAction>
           <FermAct>CLOVER</FermAct>
           <Mass>0.05</Mass>
           <clovCoeff>1.0</clovCoeff>
           <AnisoParam>
             <anisoP>false</anisoP>
           </AnisoParam>
           <FermionBC>
             <FermBC>SIMPLE_FERMBC</FermBC>
             <boundary>1 1 1 -1</boundary>
           </FermionBC>
          </FermionAction>
          <InvertParam>
            <invType>CG_INVERTER</invType>
            <RsdCG>1.0e-8</RsdCG>
            <MaxCG>1000</MaxCG>
          </InvertParam>
        </Propagator>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_files><elem>./colorvec.mod</elem></colorvec_files>
        <dist_op_file>unsmeared_meson.sdb</dist_op_file>
      </NamedObject>
    </elem>

]#



