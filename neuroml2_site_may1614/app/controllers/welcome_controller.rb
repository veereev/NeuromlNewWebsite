# Redmine - project management software
# Copyright (C) 2006-2013  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class WelcomeController < ApplicationController
  caches_action :robots

def index
    @news = News.latest User.current
    @projects = Project.latest User.current
end

def model_submit
@cells=Modelupload.all
end
def sitemap

end

def submission
@fname=params[:fname].to_s
@mname=params[:mname].to_s
@lname = params[:lname].to_s
@email = params[:email].to_s
@institution = params[:instname].to_s
@modelname = params[:model].to_s
@model_contributor = params[:model_contributor].to_s
@pubmed=params[:pubmed].to_s
@modref = params[:refrences].to_s
@moddesc = params[:model_desc].to_s
@keywords = params[:keywords_model].to_s
@comments = params[:notes].to_s
 @post = params[:file]
@model_dir = Dir.home + "/models/" + (@modelname.split(' ')).join('_')
if @post.blank? or @fname.blank? or @modelname.blank? or @lname.blank? or @email.blank?
redirect_to('/submission_error')

else
Dir.mkdir(@model_dir.to_s, 0700) #=> 0

target_file =  @model_dir + "/" + @post.original_filename
upload_file = File.open(target_file.to_s,"wb")
upload_file .write(@post.read)
upload_file.close
@test=Array.new
@test=params[:pubmed]
#@test.each do |num|
#xxi3puts num
#end

@fpath = target_file.to_s
Modelupload.create(:FirstName => @fname,:MiddleName => @mname,:LastName => @lname,:ModelName => @modelname,:Email => @email,:Institution => @institution,:Publication => @pubmed,:Modelref => @modref,:Description => @moddesc,:Contributor => @model_contributor,:Modelspath => @fpath,:Keywords => @keywords,:Comments => @comments)
end
end
def ad_model

seq_nbr=Sequence.find_by_Attr_Name("Model_ID");
@seq_nbr_model =seq_nbr.Seq_Nbr
seq_nbr=Sequence.find_by_Attr_Name("Metadata_ID");
@seq_nbr_metadata = seq_nbr.Seq_Nbr;
seq_nbr=Sequence.find_by_Attr_Name("Person_ID");
@seq_nbr_pid = seq_nbr.Seq_Nbr;
@firname = params[:fname0].to_s;
@lasname = params[:lname0].to_s;
@find_person=Person.where(:Person_First_Name => @firname,:Person_Last_Name => @lasname)
if @find_person.blank?
puts "nuill"
end
per=Person.new
@find_person.each do |per|
puts per.Person_ID
end
puts per.Person_ID
end

def add_model
@model_name=params[:model].to_s
@model_type=params[:mtype_select].to_s
@model_description = params[:model_desc].to_s
@upload_time = DateTime.now.to_s(:db)
@file_path = params[:fpath].to_s
@pubmed_title = params[:pubmed_title].to_s
@pubmed_id = params[:pubmed_id].to_s
@ref_src = params[:ref_src].to_s
@ref_uri = params[:ref_uri].to_s
@nlx_uri = params[:nlx_uri].to_s
@nlx_trm = params[:nlx_trm].to_s
@other_kwords = params[:keywords_model].to_s
@comments = params[:notes].to_s

seq_nbr1=Sequence.find_by_Attr_Name("Model_ID");
@seq_nbr_model =seq_nbr1.Seq_Nbr
seq_nbr2=Sequence.find_by_Attr_Name("Metadata_ID");
@seq_nbr_metadata = seq_nbr2.Seq_Nbr;
seq_nbr3=Sequence.find_by_Attr_Name("Person_ID");
@seq_nbr_pid = seq_nbr3.Seq_Nbr;

@post = params[:file]
@model_dir = Dir.home + "/models/" + (@model_name.split(' ')).join('_')
Dir.mkdir(@model_dir.to_s, 0700) #=> 0

target_file =  @model_dir + "/" + @post.original_filename
upload_file = File.open(target_file.to_s,"wb")
upload_file .write(@post.read)
upload_file.close

@fpath = target_file.to_s


@format_mid = '%06i' % @seq_nbr_model
if @model_type == 'C' 
@modelid = "NMLCL" + @format_mid
Model.create(:Model_ID => @modelid)
Cell.create(:Cell_ID => @modelid, :Cell_Name => @model_name, :MorphML_File => @file_path, :Upload_Time => @upload_time, :Comments => @model_description, :MorphML_File => @fpath); 
end
if @model_type == 'S' 
@modelid = "NMLSY" + @format_mid
Model.create(:Model_ID => @modelid)
Synapse.create(:Synapse_ID => @modelid, :Synapse_Name => @model_name, :Synapse_File => @file_path, :Upload_Time => @upload_time, :Comments => @model_description);
end
if @model_type == "Ch"
@modelid = "NMLCH" + @format_mid
Model.create(:Model_ID => @modelid)
Channel.create(:Channel_ID => @modelid, :Channel_Name => @model_name, :ChannelML_File => @file_path, :Upload_Time => @upload_time, :Comments => @model_description, :ChannelML_File =>  @fpath);
end
if @model_type == 'N'
@modelid = "NMLNT" + @format_mid
Model.create(:Model_ID => @modelid)
Network.create(:Network_ID => @modelid, :Network_Name => @model_name, :NetworkML_File => @file_path, :Upload_Time => @upload_time, :Comments => @model_description , :NetworkML_File => @fpath);
end
seq_nbr1.Seq_Nbr = @seq_nbr_model + 1;
seq_nbr1.save;

@format_mid = '%06i' % @seq_nbr_metadata
@metadata_id = "1" + @format_mid
@person_fname = params[:fname0].to_s
if !@person_fname.blank?
Metadata.create(:Metadata_ID => @metadata_id);
ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
AuthorList.create(:AuthorList_ID => @metadata_id);
(0..5).each do |i|
@format_pid = '%06i' % @seq_nbr_pid;
@person_id = "2" + @format_pid;
@temp_var= "fname" + i.to_s
@person_fname = params[@temp_var].to_s
@temp_var= "mname" + i.to_s
@person_mname = params[@temp_var].to_s
@temp_var= "lname" + i.to_s
@person_lname = params[@temp_var].to_s
@temp_var= "email" + i.to_s
@person_email = params[@temp_var].to_s
@temp_var= "instname" + i.to_s
@person_inst = params[@temp_var].to_s
@temp_var= "cont_select" + i.to_s
@person_contrib = params[@temp_var].to_s
if !@person_fname.blank?
@find_person=Person.where(:Person_First_Name => @person_fname,:Person_Last_Name => @person_lname)
if @find_person.blank?
Person.create(:Person_ID =>@person_id,:Person_First_Name => @person_fname,:Person_Middle_Name =>@person_mname,:Person_Last_Name => @person_lname,:Instituition => @person_inst,:Email => @person_email);
AuthorListAssociation.create(:AuthorList_ID => @metadata_id,:Person_ID => @person_id,:is_translator => @person_contrib);
@seq_nbr_pid = @seq_nbr_pid+1
else
per=Person.new
@find_person.each do |per|
@person_id = per.Person_ID
end
AuthorListAssociation.create(:AuthorList_ID => @metadata_id,:Person_ID => @person_id,:is_translator => @person_contrib);
end
end
end

end

seq_nbr3.Seq_Nbr = @seq_nbr_pid
seq_nbr3.save

if !@pubmed_id.blank?
@metadata_id = "6" + @format_mid
Metadata.create(:Metadata_ID => @metadata_id);
ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
Publication.create(:Publication_ID => @metadata_id,:Pubmed_Ref => @pubmed_id, :Full_Title => @pubmed_title);  
end 
if !@ref_uri.blank?
@metadata_id = "5" + @format_mid
Metadata.create(:Metadata_ID => @metadata_id);
ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
Reference.create(:Reference_ID => @metadata_id,:Reference_Resource => @ref_src,:Reference_URI => @ref_uri);
end
if !@nlx_uri.blank?
@metadata_id = "3" + @format_mid
Metadata.create(:Metadata_ID => @metadata_id);
ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
Neurolex.create(:NeuroLex_ID => @metadata_id,:NeuroLex_URI =>@nlx_uri,:NeuroLex_Term => @nlx_trm);
end
if !@other_kwords.blank?
@metadata_id = "4"  + @format_mid
Metadata.create(:Metadata_ID => @metadata_id);
ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
OtherKeyword.create(:Other_Keyword_ID => @metadata_id, :Other_Keyword_term => @other_kwords, :Comments => @comments);
end
seq_nbr2.Seq_Nbr = @seq_nbr_metadata + 1; 
seq_nbr2.save;

if !params[:assoc_chnl].to_s.blank?
@associated_models = params[:assoc_chnl].to_s.split(' ')
@associated_models.each do |each_model|
if @model_type == 'C'
CellChannelAssociation.create(:Cell_ID => @modelid,:Channel_ID => each_model);
end
end
end

if !params[:assoc_cell].to_s.blank?
@associated_models = params[:assoc_cell].to_s.split(' ')
@associated_models.each do |each_model|
if @model_type == 'Ch'
CellChannelAssociation.create(:Channel_ID => @modelid,:Cell_ID => each_model);
end
if @model_type == 'S'
CellSynapseAssociation.create(:Synapse_ID => @modelid,:Cell_ID => each_model);
end
if @model_type == 'N'
NetworkCellAssociation.create(:Network_ID => @modelid,:Cell_ID => each_model);
end
end
end

if !params[:assoc_syn].to_s.blank?
@associated_models = params[:assoc_syn].to_s.split(' ')
@associated_models.each do |each_model|
if @model_type == 'C'
CellSynapseAssociation.create(:Cell_ID => @modelid,:Synapse_ID => each_model);
end
if @model_type == 'N'
NetworkSynapseAssociation.create(:Network_ID => @modelid,:Synapse_ID => each_model);
end
end
end

if !params[:assoc_nw].to_s.blank?
@associated_models = params[:assoc_nw].to_s.split(' ')
@associated_models.each do |each_model|
if @model_type == 'C'
NetworkCellAssociation.create(:Cell_ID => @modelid,:Network_ID => each_model);
end
if @model_type == 'S'
NetworkSynapseAssociation.create(:Synapse_ID => @modelid,:Network_ID => each_model);
end

end
end

end

def model_info
@model_id=params[:model_id].to_s
substring=@model_id[0..4]
@channel_list=Array.new
@network_list=Array.new
@cell_list = Array.new
@syn_list = Array.new
@auth_list = Array.new
@trans_list = Array.new
@nlx_list = Hash.new
@ref_list = Hash.new
@pub_list = Hash.new
if substring ==  "NMLCL"
cell=Cell.find_by_Cell_ID(@model_id.to_s)
@name=cell.Cell_Name
@type="Cell"
@file=cell.MorphML_File

cell_channel_assoc=CellChannelAssociation.where(:Cell_ID => @model_id.to_s)
cca=CellChannelAssociation.new
cell_channel_assoc.each do |cca|
@channel = cca.Channel_ID
@channel_list.push(@channel)
end

#cell_synapse_assoc=CellSynpaseAssociation.where(:Cell_ID => @model_id.to_s)
#csa=CellSynpaseAssociation.new
#cell_synapse_assoc.each do |csa|
#@synapse = csa.Synapse_ID
#puts @synapse
#end

cell_network_assoc=NetworkCellAssociation.where(:Cell_ID => @model_id.to_s)
cna=NetworkCellAssociation.new
cell_network_assoc.each do |cna|
@network = cna.Network_ID
@network_list.push(@network)
end
end

if substring == "NMLCH"
channel=Channel.find_by_Channel_ID(@model_id.to_s)
@name=channel.Channel_Name
@type="Channel"
@file=channel.ChannelML_File

channel_cell_assoc=CellChannelAssociation.where(:Channel_ID => @model_id.to_s)
cca=CellChannelAssociation.new
channel_cell_assoc.each do |cca|
@cell = cca.Cell_ID
@cell_list.push(@cell)
end
end


if substring == "NMLNT"
network=Network.find_by_Network_ID(@model_id.to_s)
@name=network.Network_Name
@type="Network"
@file=network.NetworkML_File

network_cell_assoc=NetworkCellAssociation.where(:Network_ID => @model_id.to_s)
nca=NetworkCellAssociation.new
network_cell_assoc.each do |nca|
@cell = nca.Cell_ID
@cell_list.push(@cell)
end

#network_syn_assoc=NetworkSynapseAssociation.where(:Network_ID => @model_id.to_s)
#nsa=NetworkSynapseAssociation.new
#network_syn_assoc.each do |nsa|
#@synapse = nsa.Synapse_ID
#@syn_list = @syn_list + " " + @synapse
#end
end

#if substring == "NMLSY"
#synapse=Synapse.find_by_Synapse_ID(@model_id.to_s)
#@name=synapse.Synapse_Name
#@type="Syanpse"
#@file=synapse.SynapseML_File
#end

model_metadata_assoc=ModelMetadataAssociation.where(:Model_ID => @model_id.to_s)
res=ModelMetadataAssociation.new
model_metadata_assoc.each do |res|
@metadata_id=res.Metadata_ID.to_s
substring2=@metadata_id[0..2]

if substring2 == "600"
	publication=Publication.find_by_Publication_ID(@metadata_id)
	@pub_list[publication.Pubmed_Ref]=publication.Full_Title
end

if substring2 == "500"
ref=Reference.find_by_Reference_ID(@metadata_id)
@ref_list[ref.Reference_URI] = ref.Reference_Resource
end

if substring2 == "400"
keyword_model=OtherKeyword.find_by_Other_Keyword_ID(@metadata_id)
@keywords_model=keyword_model.Other_Keyword_term
end

if substring2 == "300"
nlx=Neurolex.find_by_NeuroLex_ID(@metadata_id)
@nlx_list[nlx.NeuroLex_URI]= nlx.NeuroLex_Term
end

if substring2 == "200"

end

if substring2 == "100"
authlist=AuthorListAssociation.where(:AuthorList_ID => @metadata_id.to_s)
ala=AuthorListAssociation.new
authlist.each do |ala|
translator=ala.is_translator.to_s
auth_name=String.new
personname=Person.find_by_Person_ID(ala.Person_ID)
auth_name = personname.Person_First_Name.to_s + " " +personname.Person_Middle_Name.to_s + " " + personname.Person_Last_Name.to_s
@auth_list.push(auth_name)
if translator == "0"
#@auth_list.push(ala.Person_ID)
elsif translator == "1"
@trans_list.push(ala.Person_ID)
else @trans_list.push(ala.Person_ID)
end
end
end
end


#keyword_model=KeywordSymbolTable.find_by_Model_ID(@model_id.to_s)
#@keywords_model=keyword_model.Keyword
filename=@file.split('/')
@filename=filename.last
render :partial => "model_info"


end




 def search_result
render :layout => 'searchresults'
 end

#============================== Python Search
def search_python
search_text=params[:q]
@resultset=`/usr/bin/python /tmp/Neurolex_py/pseudo_main.py #{search_text}`
puts 'getting stuff'
puts search_text
if @resultset.to_s.length == 0
render :partial => 'no_results' and return
end

puts @resultset.to_s
resultstring=@resultset.to_s
indexdiff = 0

indexdiff=resultstring.index('}') - resultstring.index('{')

if indexdiff != 1

cleanstring=resultstring[resultstring.index('{')..resultstring.index(']}')+1]
cleanstring=cleanstring.gsub(':','=>')
@result_hash=eval(cleanstring)

@ont_headers=Array.new
@ont_ids=Array.new
@ont_names=Array.new
@ont_types=Array.new
for key,value in @result_hash
@ont_headers.push(key)
temparray=value.to_a
 for eachid in temparray
 substring=eachid[0..4]
puts"\n\n************"+substring
if substring ==  "NMLCL"
cell=Cell.find_by_Cell_ID(eachid.to_s)
name=cell.Cell_Name
type="Cell"
end

if substring == "NMLCH"
channel=Channel.find_by_Channel_ID(eachid.to_s)
name=channel.Channel_Name
type="Channel"
end


if substring == "NMLNT"
network=Network.find_by_Network_ID(eachid.to_s)
name=network.Network_Name
type="Network"
end

#if substring == "NMLSY"
#name=Synapse.find_by_Synapse_ID(eachid.to_s)
#type="Syanpse"
#end
@ont_ids.push(eachid)
@ont_names.push(name)
@ont_types.push(type)
 end

end
end

if   indexdiff != 1
render :partial => 'ontology_search_results', :locals => {:ont_ids=>@ont_ids,:ont_names=>@ont_names,:ont_types=>@ont_types,:result_hash=>@result_hash}
else
render :partial => 'no_results'
end
end

#============================================ End of Python Search ================


#===================================== Keyword Search ======================
def search_process
search_text=params[:q].to_s
all=params[:all].to_s
exact=params[:exact].to_s
any=params[:any].to_s
none=params[:none].to_s
advanced_query=""

if all != ""
all=all.split(' ')
all_like=all.map {|x| "keyword like " + "'%" + x + "%'" }
all_like=all_like.join(' and ')
advanced_query=all_like
end

if exact != "" && all != ""
exact="'%"+exact+"%'"
advanced_query = advanced_query + " and keyword like " + exact
end

if exact != "" && all == ""
exact="'%"+exact+"%'"
advanced_query = "keyword like " + exact
end

if any != "" and ( all != "" or exact != "" )
any=any.split(' ')
any_like=any.map { |x| "keyword like " + "'%" + x + "%'" }
any_like=any_like.join(' or ')
advanced_query = advanced_query + " and (" + any_like + ")"
end

if any != "" and all == "" and exact == ""
any=any.split(' ')
any_like=any.map { |x| "keyword like " + "'%" + x + "%'" }
any_like=any_like.join(' or ')
advanced_query = "(" + any_like + ")"
end

if none != "" and (all != "" or exact != "" or any != "")
none=none.split(' ')
none_not_like=none.map { |x| "keyword not like " + "'%" + x + "%'" }

none_not_like=none_not_like.join(' and ')

advanced_query=advanced_query + " and " + none_not_like

end

if none != "" and all == "" and exact == "" and any == ""
none=none.split(' ')
none_not_like=none.map { |x| "keyword not like " + "'%" + x + "%'" }

none_not_like=none_not_like.join(' and ')

advanced_query= none_not_like
end





advanced_query = "SELECT Model_ID FROM keyword_symbol_tables WHERE "+advanced_query
puts "\n\n***********************************\n\n"+advanced_query+"\n\n**********************\n\n"

parameter_search_text=search_text.split.join(" ")
 keyword_array=parameter_search_text.split(' ')
 keyword_count=keyword_array.size

connection = ActiveRecord::Base.connection();
if all != "" or exact != "" or any != "" or none != ""
@resultset = connection.execute("#{advanced_query}");
else
@resultset = connection.execute("call keyword_search('#{parameter_search_text}',#{keyword_count})");
end
ActiveRecord::Base.clear_active_connections!()

@resultset.each do |res|
puts res
end
@resultset_strings = @resultset.map { |result| result.to_s.gsub(/[^0-9A-Za-z]/, '')}
@model_ids=Array.new
@model_names=Array.new
@model_types=Array.new
@resultset_strings.each do |result|
substring=result[0..4]
puts"\n\n************"+substring
if substring ==  "NMLCL"
cell=Cell.find_by_Cell_ID(result.to_s)
name=cell.Cell_Name
type="Cell"
end

if substring == "NMLCH"
channel=Channel.find_by_Channel_ID(result.to_s)
name=channel.Channel_Name
type="Channel"
end


if substring == "NMLNT"
network=Network.find_by_Network_ID(result.to_s)
name=network.Network_Name
type="Network"
end

#if substring == "NMLSY"
#name=Synapse.find_by_Synapse_ID(result.to_s)
#type="Syanpse"
#end

@model_ids.push(result)
@model_names.push(name)
@model_types.push(type)
puts "result-"+result+"name-"+name.to_s
end

if @model_ids.count != 0
render :partial => 'keyword_results_list',:locals => {:model_ids => @model_ids,:model_names => @model_names,:model_types => @model_types}
else
render :partial => 'no_results'
end


 end

#====================================== End of Keyword Search =============


  def robots
    @projects = Project.all_public.active
    render :layout => false, :content_type => 'text/plain'
  end
  def neuromlv2
  end
  def extend_neuroml
  end
  def lems
  end
  def relevant_publications
  end
  def workshops
  end
  def tool_support
  end
  def validate
  end
  def neuron_tools
  end
  def pynn
  end
  def x3dtools 
  end
  def browse_models
  end
  def search_result 
  end 
  def history
  end 
  def scientific_committee
  end
  def acknowledgements
  end
  def lems_dev
  end
  def libnml
  end
  def compatibility
  end
  def specifications
  end
  def examples
  end
  def introduction
  end
  def newsevents
  end
  def workshop2012
  end
  def workshop2011
  end
  def workshop2010
  end
  def workshop2009
  end
  def CNS_workshop
  end
end
