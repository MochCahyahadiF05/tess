<template>
    <div>

        <div class="btn-menuju-dunia-lain mb-3">
            <b-btn variant="success btn-md" v-if="UserAuth.hasAccess(accessRuleKey, 'c')" :to="{name:'modhr.division.form'}">
                <span>{{Trans.get('crm.divisi')}}</span>
            </b-btn>
            <b-btn variant="success btn-md" v-if="UserAuth.hasAccess(accessRuleKey, 'c')" :to="{name:'modhr.position.form'}">
                <span>{{Trans.get('crm.position')}}</span>
            </b-btn>
        </div>

        <h4 class="d-flex justify-content-between align-items-center w-100 mb-4">
            <div>{{pageTitle}}</div>
            <b-btn variant="success btn-sm" @click="showForm()" class="d-block" v-if="UserAuth.hasAccess(accessRuleKey, 'c')"> 
                <span class="ion ion-md-add"></span>&nbsp; {{Trans.get("lang.add_attribute",{attribute: Trans.get("crm.pegawai")})}}
            </b-btn>
        </h4>

        <b-card no-body>
            <!-- Table controls -->
            <b-card-body class="pb-2 pt-2">  
                <div class="row">
                    <div class="col">
                        <b-form-group :label="Trans.get('pagination.per_page')" class="d-inline-block w-auto mt-1">
                            <b-select v-model="perPage" :options="perPageOption"/>
                        </b-form-group>
                        <b-form-group :label="Trans.get('lang.search')" class="d-inline-block w-auto mt-1">
                            <b-input placeholder="Search..." v-model="searchString" />
                        </b-form-group>     
                        <b-btn variant="info" @click="doSearch" style="margin-top: -3px;" class="d-inline-block w-auto">
                            <span class="ion ion-ios-search"></span>
                        </b-btn>
                    </div>
                </div>
            </b-card-body>
            <!-- / Table controls -->

            <!-- Table -->
            <!-- <hr class="border-light m-0" /> -->
            <div class="table-responsive mb-0">
                <b-table :items="listData.data" :fields="fields" :sort-by.sync="sortBy" :sort-desc.sync="sortDesc" :striped="true" :bordered="true" :small="true" :responsive="true" class="card-table mb-0" :empty-text="noResultsText" show-empty>
                    <template v-slot:empty="scope">
                        <h5 class="text-center mb-1 mt-1">{{ scope.emptyText }}</h5>
                    </template>

                    <template v-slot:cell(no)="data">
                        {{ data.index + 1 + ((curPage-1) * perPage)}}
                    </template>
                    
                    <template v-slot:cell(nama)="data">
                        {{ data.item.nama }}
                    </template>

                    <template v-slot:cell(dob)="data">
                        {{ data.item.dob }}
                    </template>

                    <template v-slot:cell(actions)="data">
                        <b-btn @click="showForm(false, data.item.id)" variant="default btn-xs icon-btn md-btn-flat" v-b-tooltip.hover.left title="Edit" v-if="UserAuth.hasAccess(accessRuleKey, 'u')">
                            <i class="ion ion-md-create"></i>
                        </b-btn>
                        <b-btn @click="deleteData(data.item.id)" variant="danger btn-xs icon-btn md-btn-flat" v-b-tooltip.hover.left title="Remove" v-if="UserAuth.hasAccess(accessRuleKey, 'd')">
                            <i class="ion ion-md-close"></i>
                        </b-btn>
                    </template>
                </b-table>
            </div>

            <!-- Pagination -->
            <b-card-body class="pt-0 pb-3" v-if="listData.count">
                <div class="row">
                    <div class="col-sm text-sm-left text-center pt-3">
                        <span class="text-muted">Page {{ curPage }} of {{ totalPages }}</span>
                    </div>
                    <div class="col-sm pt-3">
                        <b-pagination class="justify-content-center justify-content-sm-end m-0" v-model="curPage" :total-rows="listData.count" :per-page="perPage" size="sm" />
                    </div>
                </div>
            </b-card-body>
            <!-- / Pagination -->
        </b-card>

        <!-- Modal template -->
        <b-modal id="modals-form" :size="defaultModalSize" @ok="formSubmitted" @hidden="$v.$reset" centered no-fade>
            <div slot="modal-title">
                Form / <span class="font-weight-light">{{ formTitle }}</span
                ><br />
            </div>

            <b-form-row>
                <b-form-group label="Nama Pegawai" class="col">
                    <b-input :state="$v.form.name.$error ? false : null" v-model.trim="form.name" @change="$v.form.name.$touch()" placeholder="nama" />
                    <invalid-tooltip :inputItem="$v.form.name" :fieldName="'Nama'" />
                </b-form-group>
            </b-form-row>

            <b-form-row>
                <b-form-group label="Tanggal Lahir" class="col">
                    <b-input :state="$v.form.dob.$error ? false : null" @change="$v.form.dob.$touch()" v-model.trim="form.dob" type="date" />
                    <invalid-tooltip :inputItem="$v.form.dob" :fieldName="'dob'" />
                </b-form-group>
            </b-form-row>

            <b-form-row>
                <b-form-group label="Tempat Lahir" class="col">
                    <b-input :state="$v.form.pob.$error ? false : null" @change="$v.form.pob.$touch()" v-model.trim="form.pob" placeholder="Tempat Lahir" />
                    <invalid-tooltip :inputItem="$v.form.pob" :fieldName="'pob'" />
                </b-form-group>
            </b-form-row>
            <b-form-row>
                <b-form-group label="Jenis Kelamain" class="col">
                    <b-form-radio-group :state="$v.form.sex.$error ? false : null" v-model.trim="form.sex"  @change="$v.form.sex.$touch()">
                        <b-form-radio value="L">Laki-laki</b-form-radio>
                        <b-form-radio value="P">Perempuan</b-form-radio>
                    </b-form-radio-group>
                    <invalid-tooltip :inputItem="$v.form.sex" :fieldName="'Email'" />
                </b-form-group>
            </b-form-row>

            <b-form-row>
                <b-form-group label="Divisi" class="col">
                    <b-form-select v-model.trim="form.division_id" >
                        <b-form-select-option value="a">Option A</b-form-select-option>
                        <b-form-select-option value="b">Option B</b-form-select-option>
                        <b-form-select-option value="a">Option A</b-form-select-option>
                    </b-form-select>
                </b-form-group>
            </b-form-row>

            <b-form-row>
                <b-form-group label="Position" class="col">
                    <b-form-select v-model.trim="form.position_id" >
                        <b-form-select-option value="a">Option A</b-form-select-option>
                        <b-form-select-option value="b">Option B</b-form-select-option>
                        <b-form-select-option value="a">Option A</b-form-select-option>
                    </b-form-select>
                </b-form-group>
            </b-form-row>

            <div>
                <label for="tags-basic">Tags</label>
                <b-form-tags input-id="tags-basic" v-model.trim="form.tag"></b-form-tags>
            </div>

            <b-form-row>
                <b-form-group label="Status" class="col">
                    <b-form-select v-model.trim="form.status" >
                        <b-form-select-option value="a">Option A</b-form-select-option>
                        <b-form-select-option value="b">Option B</b-form-select-option>
                        <b-form-select-option value="a">Option A</b-form-select-option>
                    </b-form-select>
                </b-form-group>
            </b-form-row>

            <b-form-row>
                <b-form-group label="Status Acount" class="col">
                    <b-form-select v-model.trim="form.account_status" >
                        <b-form-select-option value="a">Option A</b-form-select-option>
                        <b-form-select-option value="b">Option B</b-form-select-option>
                        <b-form-select-option value="a">Option A</b-form-select-option>
                    </b-form-select>
                </b-form-group>
            </b-form-row>
            
            <b-form-row>
                <b-form-group label="Note" class="col">
                    <b-textarea rows="3" v-model.trim="form.note" placeholder="Alamat" />
                </b-form-group>
            </b-form-row>

            <!-- <b-form-row>
                <b-form-group label="Telepon" class="col">
                    <b-input v-model.trim="form.telepon" placeholder="Telepon" />
                </b-form-group>
            </b-form-row> -->
            
            <!-- <b-form-row>
                <b-form-group label="Email" class="col">
                    <b-input :state="$v.form.email.$error ? false : null" @change="$v.form.email.$touch()" v-model.trim="form.email" placeholder="Email" type="date" />
                    <invalid-tooltip :inputItem="$v.form.email" :fieldName="'Email'" />
                </b-form-group>
            </b-form-row> -->

            <!-- <b-form-row>
                <b-form-group label="Keterangan" class="col">
                    <b-textarea rows="3" v-model.trim="form.keterangan" placeholder="keterangan tambahan" />
                </b-form-group>
            </b-form-row> -->

        </b-modal>
    </div>
</template>

<script>
    import { required, email } from "node_modules/vuelidate/lib/validators";
    export default {
        name: "modhr.employee.readList",
        validations: {
            form: {
                name: {
                    required
                },
                dob:{
                    required
                },
                pob:{
                    required
                },
                sex: {
                    required
                }
            }
        },
        data: () => ({
            isAdd: true,//flag untuk form input, apakah proses add atau edit
            defaultModalSize: "md",
            accessRuleKey: "modhr.employee",

            // Options
            searchString: "",
            sortBy: "id",
            sortDesc: false,
            perPage: 10,
            curPage: 1,
            perPageOption: [10,20,50,100],
            noResultsText: "Loading...",
            loadParams: {},

            fields: [
                { key: "no", sortable: false,tdClass:"text-center text-nowrap" },
                { key: "name", sortable: true, thStyle: "min-width: 5rem" },
                { key: "tanggal Lahir", sortable: true, thStyle: "min-width: 5rem" },
                { key: "tempat Lahir", sortable: true, thStyle: "min-width: 5rem" },
                { key: "jenis Kelamin ", sortable: true, thStyle: "max-width: 5rem" },
                { key: "Divisi ", sortable: true, thStyle: "min-width: 5rem" },
                { key: "Position ", sortable: true, thStyle: "min-width: 5rem" },
                { key: "status ", sortable: true, thStyle: "min-width: 5rem" },
                { key: "status acount ", sortable: true, thStyle: "min-width: 5rem" },
                { key: "note ", sortable: true, thStyle: "min-width: 10rem" , thClass:"text-center"},
                { key: "actions", label: " Actions ", tdClass: "text-center text-nowrap" }
            ],

            formEmpty: {
                id: 0,
                name: "",
                dob: "",
                pob:"",
                sex:"",
                alamat: "",
                telepon: "",
                email: "",
                keterangan: ""
            },
            // form: null
        }),
        watch: {
            curPage(v) {
                this.loadList(v,this.searchString,this.sortBy,this.sortDesc);
            },
            perPage(v) {
                this.loadList(this.curPage,this.searchString,this.sortBy,this.sortDesc);
            },
            sortBy(v) {
                this.loadList(this.curPage,this.searchString,v,this.sortDesc);
            },
            sortDesc(v) {
                this.loadList(this.curPage,this.searchString,this.sortBy, v);
            },    
            // searchString(v) {
            //     let val = v.toLowerCase();      
            //     var that = this;
            //     clearTimeout(this.suggestTimeout);
            //     this.suggestTimeout = setTimeout(function(){
            //         that.loadList(1,val);      
            //     },300);
            // }
        },
        computed: {
            pageTitle() {
                return this.Trans.chose(this.AppConfig.packageLocal.modhr.access.children.employee.caption);
            },
            formTitle() {
                return this.isAdd ? "Tambah Baru" : "Edit";
            },
            listData() {
                return this.$store.state.modhrMaster.listData;
            },
            oneData() {
                return this.$store.state.modhrMaster.oneData;
            },
            totalPages() {
                return Math.ceil(this.listData.count / this.perPage);
            }
        },
        methods: {         
            doSearch() {
                this.loadList(this.curPage,this.searchString,this.sortBy,this.sortDesc);
            },     
            loadList(curPage=1,q='',orderBy=false,sortDesc=false) {
                var offset = (this.perPage * (curPage-1));
                
                this.loadParams.limit = this.perPage;
                this.loadParams.offset = offset;

                if(q!=''){
                    this.loadParams.q = q;
                }else{
                    delete this.loadParams.q;
                }
                if(orderBy!=false){
                    this.loadParams.orderBy = orderBy;
                    this.loadParams.orderType = sortDesc?'DESC':'ASC';
                }

                this.$store.dispatch("modhrMaster/readList", {params: this.loadParams}).then(res => {
                    if (this.listData.count == 0) {
                        this.noResultsText = this.Trans.get("lang.no_data");
                        this.Web.showAlert({ 
                            title: this.Trans.get("alert.info_title"),
                            text: this.Trans.get("lang.no_data"), 
                            type: "info" 
                        });
                    }
                }).catch((res)=>{
                    this.Web.showAlert({ 
                        title: this.Trans.get("alert.warning_title"),
                        text: this.Trans.get("alert.read_failed",{attribute:this.Trans.get("crm.client")}) + "<br>\n" + res.message, 
                        type: "warning" 
                    });
                });
            },
            showForm(isAdd = true, id = 0) {
                this.isAdd = isAdd;
                if (!isAdd) {
                    this.$store
                        .dispatch("modhrMaster/readOne", {id:id})
                        .then(res => {
                            this.form = this.oneData;
                            this.$bvModal.show("modals-form");
                        })
                        .catch(res => {
                            console.log("get modhrMaster error : ", res);
                            this.Web.showAlert({ 
                                title: this.Trans.get("alert.warning_title"),
                                text: this.Trans.get("alert.read_failed",{attribute:this.Trans.get("crm.client")}) + "<br>\n" + res.message, 
                                type: "warning" 
                            });
                        });
                } else {
                    this.form = JSON.parse(JSON.stringify(this.formEmpty));
                    this.$bvModal.show("modals-form");
                }
            },
            formSubmitted(ev) {
                ev.preventDefault();
                if(this.$v){
                    this.$v.$touch();
                    if(this.$v.$error){                        
                        this.Web.showAlert({ 
                            title: this.Trans.get('alert.form_must_complete_title'), 
                            text: this.Trans.get('alert.form_must_complete_text'), 
                            type: "warning"
                        });
                        return false;
                    }
                }
                if (this.isAdd) {
                    this.saveData(this.form);
                } else {
                    this.updateData(this.form);
                }
            },
            saveData(data) {
                if (!this.UserAuth.hasAccess(this.accessRuleKey, "c")) {
                    //goto dashboard current tenant
                    this.Web.goToCurrentTenant();
                    this.Web.showAlert({ 
                        title: this.Trans.get("alert.warning_title"),
                        text: this.Trans.get("alert.access_denied"), 
                        type: "warning" 
                    });
                    return false;
                }

                this.Web.setLoadingPage(true);
                this.$store
                    .dispatch("modhrMaster/create", {data:data})
                    .then(res => {
                        this.Web.showAlert({ 
                            title: this.Trans.get("alert.success_title"),
                            text: this.Trans.get("alert.create_success",{attribute:this.Trans.get("crm.client")}), 
                            type: "success" 
                        });
                        this.$bvModal.hide("modals-form");
                        this.Web.setLoadingPage(false);
                    })
                    .catch(res => {
                        this.Web.showAlert({ 
                            title: this.Trans.get("alert.warning_title"),
                            text: this.Trans.get("alert.create_failed",{attribute:this.Trans.get("crm.client")}) + "<br>\n" + res.message, 
                            type: "warning" 
                        });
                        this.Web.setLoadingPage(false);
                    });
            },
            updateData(data) {
                if (!this.UserAuth.hasAccess(this.accessRuleKey, "u")) {
                    //goto dashboard current tenant
                    this.Web.goToCurrentTenant();
                    this.Web.showAlert({ 
                        title: this.Trans.get("alert.warning_title"),
                        text: this.Trans.get("alert.access_denied"), 
                        type: "warning" 
                    });
                    return false;
                }

                this.Web.setLoadingPage(true);
                this.$store
                    .dispatch("modhrMaster/update", {data:data,id:data.id})
                    .then(res => {
                        this.Web.showAlert({ 
                            title: this.Trans.get("alert.success_title"),
                            text: this.Trans.get("alert.update_success",{attribute:this.Trans.get("crm.client")}), 
                            type: "success" 
                        });
                        this.$bvModal.hide("modals-form");
                        this.Web.setLoadingPage(false);
                    })
                    .catch(res => {
                        this.Web.showAlert({ 
                            title: this.Trans.get("alert.warning_title"),
                            text: this.Trans.get("alert.update_failed",{attribute:this.Trans.get("crm.client")}) + "<br>\n" + res.message, 
                            type: "warning" 
                        });
                        this.Web.setLoadingPage(false);
                    });
            },
            deleteData(id) {
                if (!this.UserAuth.hasAccess(this.accessRuleKey, "d")) {
                    //goto dashboard current tenant
                    this.Web.goToCurrentTenant();
                    this.Web.showAlert({ 
                        title: this.Trans.get("alert.warning_title"),
                        text: this.Trans.get("alert.access_denied"), 
                        type: "warning" 
                    });
                    return false;
                }

                this.Web.showAlert({
                    styleType: "modal",
                    type: "warning",
                    title: this.Trans.get("alert.delete_confirm_title"),
                    text: this.Trans.get("alert.delete_confirm_text"),
                    modalButtonCancel: this.Trans.get("lang.no"),
                    modalButtonOk: this.Trans.get("lang.yes"),
                    onOk: () => {
                        this.$store
                            .dispatch("modhrMaster/delete", {id:id})
                            .then(res => {
                                this.Web.showAlert({ 
                                    title: this.Trans.get("alert.success_title"),
                                    text: this.Trans.get("alert.delete_success",{attribute:this.Trans.get("crm.client")}), 
                                    type: "success" 
                                });
                            })
                            .catch(res => {
                                this.Web.showAlert({ 
                                    title: this.Trans.get("alert.warning_title"),
                                    text: this.Trans.get("alert.delete_failed",{attribute:this.Trans.get("crm.client")}) + "<br>\n" + res.message, 
                                    type: "warning" 
                                });
                            });
                    }
                });
            }
        },
        created() {
            if (!this.UserAuth.hasAccess(this.accessRuleKey)) {
                //goto dashboard current tenant
                this.Web.goToCurrentTenant();
                this.Web.showAlert({ 
                    title: this.Trans.get("alert.warning_title"),
                    text: this.Trans.get("alert.access_denied"), 
                    type: "warning" 
                });
                return false;
            }

            //jika tidak punya access edit/delete maka hilangkan kolom aksi
            if (!(this.UserAuth.hasAccess(this.accessRuleKey, "u") || this.UserAuth.hasAccess(this.accessRuleKey, "d"))) {
                this.fields.splice(4, 1);
            }

            this.Web.setNavbarTitle(this.Trans.chose(this.AppConfig.packageLocal.modhr.access.caption));
            this.Web.appendNavbarTitle(this.Trans.chose(this.AppConfig.packageLocal.modhr.access.children.employee.caption));

            //reload list data
            this.loadList();
            this.form = JSON.parse(JSON.stringify(this.formEmpty));
        }
    };
</script>