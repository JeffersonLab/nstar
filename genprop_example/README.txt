How to run CHROMA/GENPROP on CORI

There's a little test job script that should make it clear how to launch.

It's safe to stick to 8 Chroma processes per compute node while each uses 8 threads. (That's how the test script is set up.) Then there's no need to alter the value for "nodes_per_cn" in the chroma input file.


The equation for the correlator length is

Nt_forward = [number of nodes] * [harom #/node].


The general usage for the launcher:

./launcher [ENV MPI RANK] [ranks per node] [chroma_exe] [chroma OMP] [chroma stdout] [harom_exe] [harom OMP] [harom stdout] [harom #/node] [harom FIFO stem] [harom LS] [chroma args..]



In the chroma input file make sure that

1) [harom #/node] equals the number of elements of <fifo>

2) <Nt_forward> equals the above number

3) <nodes_per_cn> equals [ranks per node]

4) the enumeration of the [harom FIFO stem] (<fifo>) starts with "1"


Example:


        <Contractions>
          <num_vecs>4</num_vecs>
          <mass_label>U-0.0856</mass_label>
          <decay_dir>3</decay_dir>
          <displacement_length>1</displacement_length>
          <num_tries>0</num_tries>
	  <t_start>0</t_start>
	  <Nt_forward>8</Nt_forward>
	  <fifo>
	    <elem>/tmp/harom-cmd1</elem>
	    <elem>/tmp/harom-cmd2</elem>
	    <elem>/tmp/harom-cmd3</elem>
	    <elem>/tmp/harom-cmd4</elem>
	  </fifo>
	  <nodes_per_cn>8</nodes_per_cn>
        </Contractions>


Frank

