
  //----------------------------------------------------------------------------------
  //! Parameters
  struct Param_t
  {
    string                runmode;                     /*!< "diag", "offdiag", "offdiagIsospin", "default" */
    bool                       include_all_rows;            /*!< All the rows of the irrep? */
    string                source_ops_list;             /*!< List of source ops */
    string                sink_ops_list;               /*!< List of sink ops */
    vector<string>   ops_xmls;                    /*!< The XML files for all of the ops */
    vector< Array<int> >  moms;                        /*!< The actual momentum - not mom_type */
    vector<int>           t_sources;                   /*!< Array of all the requested time-sources */
  };


  //! Input Files 
  void read(XMLReader& xml, const string& path, Param_t& input)
  {
    XMLReader inputtop(xml, path);

    read(inputtop, "runmode", input.runmode);
    read(inputtop, "include_all_rows", input.include_all_rows);
    read(inputtop, "source_ops_list", input.source_ops_list);
    read(inputtop, "sink_ops_list", input.sink_ops_list);
    read(inputtop, "ops_xmls", input.ops_xmls);
    read(inputtop, "moms", input.moms);
    read(inputtop, "t_sources", input.t_sources);
  }


  //----------------------------------------------------------------------------------
  //----------------------------------------------------------------------------------
  //! Create corr keys from operator list
  class Redstar2Pts
  {
  public:
    Redstar2Pts() {}
    virtual ~Redstar2Pts() {}

    //! The function call
    virtual list<KeyHadronSUNNPartNPtCorr_t> operator()(const vector<pair<string, string> >& source_ops_list,
							     const vector<pair<string, string> >& sink_ops_list,
							     const map<string, KeyHadronSUNNPartIrrepOp_t>& ops_map,
							     const Array<int>& mom,
							     bool include_all_rows,
							     const vector<int>& t_sources) = 0;
  };


  //----------------------------------------------------------------------------------
  //----------------------------------------------------------------------------------
  //! Diagonal method
  class Redstar2PtsDiag : public Redstar2Pts
  {
  public:
    Redstar2PtsDiag() {}
    ~Redstar2PtsDiag() {}

    // Do the thing Julie
    list<KeyHadronSUNNPartNPtCorr_t> operator()(const vector<pair<string, string> >& source_ops_list,
						     const vector<pair<string, string> >& sink_ops_list,
						     const map<string, KeyHadronSUNNPartIrrepOp_t>& ops_map,
						     const Array<int>& mom,
						     bool include_all_rows,
						     const vector<int>& t_sources)
    {
      return printRedstar2PtsDiag(source_ops_list, sink_ops_list, ops_map, mom, include_all_rows, t_sources);
    }
  };

  //! Default method
  Redstar2Pts* workRedstar2PtsDiag(void)
  {
    return new Redstar2PtsDiag();
  }


  //----------------------------------------------------------------------------------
  //----------------------------------------------------------------------------------
  //! Off-diagonal method
  class Redstar2PtsOffDiag : public Redstar2Pts
  {
  public:
    Redstar2PtsOffDiag() {}
    ~Redstar2PtsOffDiag() {}

    // Do the thing Julie
    list<KeyHadronSUNNPartNPtCorr_t> operator()(const vector<pair<string, string> >& source_ops_list,
						     const vector<pair<string, string> >& sink_ops_list,
						     const map<string, KeyHadronSUNNPartIrrepOp_t>& ops_map,
						     const Array<int>& mom,
						     bool include_all_rows,
						     const vector<int>& t_sources)
    {
      return printRedstar2PtsOffDiag(source_ops_list, sink_ops_list, ops_map, mom, include_all_rows, t_sources);
    }
  };

  //! Default method
  Redstar2Pts* workRedstar2PtsOffDiag(void)
  {
    return new Redstar2PtsOffDiag();
  }



  //----------------------------------------------------------------------------------
  //----------------------------------------------------------------------------------
  //! Default method
  class Redstar2PtsDefault : public Redstar2Pts
  {
  public:
    Redstar2PtsDefault() {}
    ~Redstar2PtsDefault() {}

    // Do the thing Julie
    list<KeyHadronSUNNPartNPtCorr_t> operator()(const vector<pair<string, string> >& source_ops_list,
						     const vector<pair<string, string> >& sink_ops_list,
						     const map<string, KeyHadronSUNNPartIrrepOp_t>& ops_map,
						     const Array<int>& mom,
						     bool include_all_rows,
						     const vector<int>& t_sources)
    {
      return printRedstar2PtsDefault(source_ops_list, sink_ops_list, ops_map, mom, include_all_rows, t_sources);
    }
  };

  //! Default method
  Redstar2Pts* workRedstar2PtsDefault(void)
  {
    return new Redstar2PtsDefault();
  }



//----------------------------------------------------------------------------
//! Generate redstar NPoint input xml for two-point functions and a list of source/sink ops
/*!
 * Generate redstar NPoint input xml for two-point functions and a list of source/sink ops
 */

int main(int argc, char *argv[])
{
    cout << "\nRead XML input file = " << argv[1] << endl;
    Param_t params; 
    {
      XMLReader xml_in(argv[1]);
      read(xml_in, "/GenerateXML", params);
    }

    // Read the operator list file
    cout << "Read source ops" << endl;
    fred source_ops_list = readOpsList(params.source_ops_list);
    cout << "Found " << source_ops_list.size() << " source ops\n" << endl;

    cout << "Read sink ops" << endl;
    fred sink_ops_list   = readOpsList(params.sink_ops_list);
    cout << "Found " << sink_ops_list.size() << " sink ops\n" << endl;
    
    // Read the operator maps
    cout << "Read ops map" << endl;
    fred ops_map = readOpsMap(params.ops_xmls);
    cout << "Found " << ops_map.size() << " total number of entries in ops_map\n" << endl;

    // Output corrs
    Handle<Redstar2Pts> red = TheKeyHandlerObjFuncMap::Instance().createObject(params.runmode);

    // Select the irreps commensurate with the momentum
    cout << "Build 2pt correlation functions" << endl;
    list<KeyHadronSUNNPartNPtCorr_t> corrs;

    for( mom = params.moms.begin(); mom != params.moms.end(); ++mom)
    {
      fred tmp = (*red)(source_ops_list,
			sink_ops_list,
			ops_map,
			*mom,
			params.include_all_rows,
			params.t_sources);

      cout << "Found ";
      cout.width(5);
      cout << tmp.size() << "  corr funcs compatible with mom= " << *mom << endl;

      corrs.insert(corrs.end(), tmp.begin(), tmp.end());
    }

    // Print keys
    cout << "\nWrite out " << corrs.size() << " total number of corr funcs 2pt xml" << endl;
    XMLFileWriter xml_out(argv[2]);
    write(xml_out, "NPointList", corrs);
    xml_out.close();
}
