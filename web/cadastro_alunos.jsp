<%-- 
    Document   : index
    Created on : 25/10/2016, 15:08:38
    Author     : Lamara
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Array"%>
<%@page import="com.sishistorico.dao.DaoTipo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!-- meta-data -->



<!DOCTYPE html>
<html>
    <%@include file="partes/meta-data.jsp" %>    
    <!-- #Meta-data ------------------------------------------------------------------------------------------------->
    <body class="hold-transition skin-blue sidebar-mini">
        <div class="pull-right-container fixed" style=" z-index: 500; margin-left: 70%; margin-top: 2%; max-width: 30%">
            <div id="alert" class="alert alert-success fade">
                <button type="button" class="close" data-dismiss="alert">×</button>
                <strong>Sucesso!</strong>
                <div id="msg">
                </div>    
            </div>
        </div> 
        <div class="wrapper">
            <!-- Menu-Topo -->   
            <%@include file="partes/menu-topo.jsp" %>    

            <!-- #fecha MEnu-top ------------------------------------------------------------------------------------------->
            <!-- Menu-lateral -->
            <%@include file="/partes/menu-lateral.jsp" %> 
            <!--#FEcha  Menu-lateral -->

            <!-- Conteúdo ------------------------------------------------------------------------------------------------->
            <div class="content-wrapper">
                <div class="box">
                    <div class="box-header">
                        <h2 class="box-title">Cadastro de usuários</h2>
                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                                <i class="fa fa-minus"></i></button>
                            <button type="button" class="btn btn-box-tool" data-widget="remove" data-toggle="tooltip" title="Remove">
                                <i class="fa fa-times"></i></button>
                        </div>
                    </div>

                    <div class="box-body">
                        <p>Obs: Campos com "*" são obrigatórios</p>

                        <form data-toggle="validator" enctype="multipart/form-data"  method="post" acceptcharset="UTF-8" action="SvCadastraEleitor">
                          
                            <div class="row">
                                <div class="col-md-6">
                                    <button id="salvar" type="submit" class="btn btn-block btn-success btn-lg">Salvar</button>
                                </div>
                                <div class="col-md-6">
                                    <button onclick="limpar2()" id="limpar" type="button" class="btn btn-block btn-primary btn-lg disabled">Limpar</button>
                                </div>
                            </div>
                        </form>
                        <!-- fecha formulário -->
                    </div> 
                </div>
<script type="text/javascript" >
    
    function limpa_formulário_cep() {
            //Limpa valores do formulário de cep.
           document.getElementById('rua').value="";
           document.getElementById('bairro').value="";
          document.getElementById('cidade').value="";
            //document.getElementById('uf').value=("");
            //document.getElementById('ibge').value=("");
    }

    function meu_callback(conteudo) {
        if (!("erro" in conteudo)) {
            //Atualiza os campos com os valores.
            document.getElementById('rua').value=(conteudo.logradouro);
            document.getElementById('bairro').value=(conteudo.bairro);
            document.getElementById('cidade').value=(conteudo.localidade);
            //document.getElementById('uf').value=(conteudo.uf);
            //document.getElementById('ibge').value=(conteudo.ibge);
        } //end if.
        else {
            //CEP não Encontrado.
            limpa_formulário_cep();
            alert("CEP não encontrado.");
        }
    }
        
    function pesquisacep() {

        //Nova variável "cep" somente com dígitos.
        var valor = document.getElementById("cep").value;
       

        var cep = valor;

        //Verifica se campo cep possui valor informado.
        if (cep != "") {

            //Expressão regular para validar o CEP.
            var validacep = /^[0-9]{8}$/;

            //Valida o formato do CEP.
            if(validacep.test(cep)) {

                //Preenche os campos com "..." enquanto consulta webservice.
                document.getElementById('rua').value = "...";
                document.getElementById('bairro').value = "...";
                document.getElementById('cidade').value = "...";
               // document.getElementById('uf').value = "...";
                //document.getElementById('ibge').value = "...";

                //Cria um elemento javascript.
                var script = document.createElement('script');

                //Sincroniza com o callback.
                script.src = 'http://viacep.com.br/ws/'+ cep + '/json/?callback=meu_callback';

                //Insere script no documento e carrega o conteúdo.
                document.body.appendChild(script);

            } //end if.
            else {
                //cep é inválido.
                limpa_formulário_cep();
                alert("Formato de CEP inválido.");
            }
        } //end if.
        else {
            //cep sem valor, limpa formulário.
           limpa_formulário_cep();
        }
    };

    </script>                                        
                <div class="box">
                    <div class="box-header">
                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                                <i class="fa fa-minus"></i></button>
                            <button type="button" class="btn btn-box-tool" data-widget="remove" data-toggle="tooltip" title="Remove">
                                <i class="fa fa-times"></i></button>
                        </div>
                    </div>
                    <%@include file="/partes/javascript.jsp" %> 

                    <div class="box-body">
                        <h2> Últimos cadastros</h2>

                        <jsp:include page="in_usuarios.jsp">
                            <jsp:param name="ids" value="1,2,3" />
                            <jsp:param name="busca" value="" />

                        </jsp:include>    
                    </div>
                </div>                               
            </div>
            <!-- #Fecha Conteúdo -->

            <!-- Abrir Rodapé -------------------------------------------------------------------------------------------->  
            <%@include file="/partes/rodape.jsp" %> 
            <!-- #Fecha rodapé -->

        </div>
        <!-- js -->

        <!-- #Fecha js-->
    </body>
</html>

<script>
    $(document).ready(function () {
        var url = location.href;
        if (url.indexOf("msgok") == -1) {

        } else {
            document.getElementById("msg").innerHTML = "<% out.print(request.getParameter("msgok"));%>";
            $("#alert").delay(2000).addClass("in").fadeOut(4000);

        }
    });

    $("#foto").fileinput({
        language: "pt",
        showUpload: false,
        showCaption: false,
        resizeImage: true,
        maxImageWidth: 200,
        maxImageHeight: 200,
        resizePreference: 'width',
        footer: false,
        overwriteInitial: false,
        initialPreviewAsData: true,
        initialPreviewAsData: true, // identify if you are sending preview data only and not the raw markup
        initialPreviewFileType: 'image' // image is the default and can be overridden in config below


    });

    $('#nascimento').datepicker({
        autoclose: true,
        format: 'dd/mm/yyyy',
        language: 'pt-BR',
        defaultDate: new Date()

    });
    $('#ddata').datepicker("update", new Date());

   
</script>
