<template>
    <div class="m-3">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
        <div>
            <h5 class="d-flex justify-content-between align-items-center w-100 mt-4 mb-4">
                
                <div class="text-center">
                    <template v-if="k=='package'">
                        <b-btn variant="secondary btn-sm" v-if="UserAuth.hasAccess(accessRuleKey, 'c')">
                            <span class="ion ion-md-code-download"></span>&nbsp; Require from GIT 
                        </b-btn>
                        <b-btn variant="secondary btn-sm" v-if="UserAuth.hasAccess(accessRuleKey, 'c')">
                            <span class="ion ion-ios-share"></span>&nbsp; Require from Local
                        </b-btn>
                    </template>
                    <b-btn variant="success btn-sm" v-if="UserAuth.hasAccess(accessRuleKey, 'c')" :to="{ name: 'modhr.employee.form' }">
                        <span class="ion ion-md-add"></span>&nbsp; Tambah Data Pegawai
                    </b-btn>
                    <b-btn variant="success btn-sm" v-b-modal.modal-position>
                        <span class="ion ion-md-add"></span>&nbsp; Tambah Data Position
                    </b-btn>
                    <b-btn variant="success btn-sm" v-b-modal.modal-divisi>
                        <span class="ion ion-md-add"></span>&nbsp; Tambah Data Division 
                    </b-btn>
                </div>
            </h5>
            <div class="modal">
                <b-modal id="modal-position" title="Form jabatan">
                    <b-form @submit="onSubmit" @reset="onReset">
                        <b-form-group id="input-group-1" label="Nama Position :" label-for="input-1">
                            <b-form-input id="input-1"  type="text" placeholder="Masukan nama Position/jabatan" required>
                            </b-form-input>
                        </b-form-group>
                        <b-form-group id="input-2" label="Description" label-for="input-2">
                            <b-form-textarea id="input-2" placeholder="Description" rows="3" max-rows="6"></b-form-textarea>
                        </b-form-group>
                        <b-form-group id="input-group-3" label="Level :" label-for="input-3">
                            <b-form-input id="input-3"  type="number" placeholder="Masukan Level" required>
                            </b-form-input>
                        </b-form-group>
                        <b-form-group id="input-group-4" label="Divisi :" label-for="input-4" description="jika bisa di semua Divisi Pilih semua Divisi">
                            <b-form-select id="input-4" placehorde="select Divisi">
                                <b-form-select-option value="0"> Semua Divisi </b-form-select-option>
                                <b-form-select-option value="khusus 1"> Divisi Khusus 1 </b-form-select-option>
                                <b-form-select-option value="khusus 2"> Divisi Khusus 2 </b-form-select-option>
                            </b-form-select>
                        </b-form-group>
                    </b-form>
                </b-modal>
            </div>
            <div class="modal-2">
                <b-modal id="modal-divisi" title="Form Divisi">
                    <b-form @submit="onSubmit" @reset="onReset">
                        <b-form-group id="input-group-1" label="Nama Divisi :" label-for="input-1">
                            <b-form-input id="input-1"  type="text" placeholder="Masukan nama divisi" required>
                            </b-form-input>
                        </b-form-group>
                        <b-form-group id="input-2" label="Description" label-for="input-2">
                            <b-form-textarea id="input-2" placeholder="Description" rows="3" max-rows="6"></b-form-textarea>
                        </b-form-group>
                        <b-form-group id="input-group-3" label="Level :" label-for="input-3">
                            <b-form-input id="input-3"  type="number" placeholder="Masukan Level" required>
                            </b-form-input>
                        </b-form-group>
                    </b-form>
                </b-modal>
            </div>
            <div class="row">
                <div v-for="project in projectsData" :key="project.title" class="col-sm-12 col-md-6 col-xl-4">
                    <b-card no-body class="mb-4">
                        <b-card-body class="d-flex justify-content-between align-items-start pb-3">
                            <div class="row">
                                <div class="col">
                                    <img :src="project.gambar" alt="" class="ui-w-60 rounded-circle">
                                </div>
                                <div class="col">
                                    <p class="text-body text-big font-weight-semibold">{{project.nama}}</p>
                                    <b class="divisi">{{project.Divisi}}</b>
                                    <p class="jabatan">{{project.jabatan}}</p>

                                </div>
                            </div>
                            <b-dropdown variant="default icon-btn borderless rounded-pill md-btn-flat hide-arrow" size="sm" :right="!isRTL">
                                <template slot="button-content"><i class="ion ion-ios-more"></i></template>
                                <b-dropdown-item href="javascript:void(0)">View</b-dropdown-item>
                                <b-dropdown-item href="javascript:void(0)">Edit</b-dropdown-item>
                                <b-dropdown-item href="javascript:void(0)">Remove</b-dropdown-item>
                            </b-dropdown>
                        </b-card-body>
                        <b-card-body class="pt-0">
                            <div class="">
                                <div>
                                    <i class="bi bi-envelope"></i> {{project.email}}
                                </div>
                                <div>
                                    <i class="bi bi-calendar"></i> {{project.tempatTgl}}
                                </div>
                            </div>
                        </b-card-body>
                        <hr class="m-0" />
                    </b-card>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import { required, email } from "node_modules/vuelidate/lib/validators";
export default {
    
    name: "modhr-employee-list",
    validations: {
            form: {
                nama: {
                    required
                },
                email: {
                    email
                }
            }
        },
    
    data: () => ({
        accessRuleKey: "modhr.employee",

        
        projectsData: [
            {
            
                nama: "Surya",
                gambar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgKu25PD59G2NpmaCtTDkxn89DCOa4K-RVNsYo2vSdtQ&s",
                jabatan: "karyawan",
                Divisi: "Editor",
                email: "surya@gmail.com",
                tempatTgl: "Bandung 21-09-2005"
            },
            {
            
                nama: "Astri",
                gambar:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNOWcQrPlfVW_CN20jcIVTrZQKnoFqqN9kLQ&usqp=CAU",
                jabatan: "karyawan",
                Divisi: "Marketing",
                email: "astri@gmail.com",
                tempatTgl: "Bandung 21-09-2005"
            },
            {
            
                nama: "Cahya",
                gambar:"data:image/png;base64,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",
                jabatan: "Manager",
                Divisi: "Produksi",
                email: "cahya@gmail.com",
                tempatTgl: "Bandung 21-09-2005"
            },
            {
            
                nama: "Davin",
                gambar:"data:image/png;base64,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",
                jabatan: "Direktur",
                Divisi: "Produksi",
                email: "davin@gmail.com",
                tempatTgl: "Bandung 21-09-2005"
            },
            {
            
                nama: "Gera",
                gambar:"data:image/jpeg;base64,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",
                jabatan: "Manager",
                Divisi: "Produksi",
                email: "gera@gmail.com",
                tempatTgl: "Bandung 21-09-2005"
            },
            {
            
                nama: "Berli",
                gambar:"data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5OjcBCgoKDQwNGg8PGjclHyU3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3N//AABEIAIgAiAMBIgACEQEDEQH/xAAbAAEAAgMBAQAAAAAAAAAAAAAAAgMBBAUGB//EADIQAAIBAwIEAwYFBQAAAAAAAAABAgMEEQUhEhMxQSJRcQYyYYGRwVJisdHhFBVCcqH/xAAUAQEAAAAAAAAAAAAAAAAAAAAA/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8A8qAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAewAEHUWTIFjWCJfJFUo4AiAAABz9b1Fafa5hh1p7QT/UCWparb6esVHxVH0px6/wAHnrn2ivarfKcKMe3Csv6s5NWpOrOU6knKcnlt9yAG9/d9Qzn+rqfU2rb2hvqTXMlCtHupLD+qOOAPc6Zq1vqC4YNwqpZdOX28zfPnVOcqc4zpycZReU12PbaPqKv7RSlhVobTX3A3wRc0jHMXkBMrqy3wYdRtEM56gADAHRayOHbBkZQFcoFZc5oom23sgB4n2gunc6nUw3wU3wR+X8nsZOXc8BcNuvUb6ubz9QKwAAAAA6Og3DoahBN+Gr4H8+hzi22bVxSa7TX6ge7BgxKSSAyCrmjj4nhAW5RgcsAb/MI8RqubbHEwNlziu5HmQ8zXZGUlEDb4odTwOrUXQ1G4p9uNtej3PYc7G2Dj+0Nrzoq5pLxwWJLzQHnAZMAAAANnT6bq3tGK/Gm/RGud7Q7PlxdxUWJSWIJ9l5gdl1GQbb7gnGm2BAtoR3ySjRXcs4VFbAZbQIgDDkkQ5qyUttgDY41gplJtkOJLuY4kBIPdYfQjxIi5Acq/0iMpOpatRb6030+RyattWpNqpSnH5bfU9UYfTfp8QPIE6dKpUeKcJS9EemlUtovxTop/FonCpSltTnB/6tAcyw0pxandLpuofudhNkqfB0Zaow80ApebNhPyKlwrujEqqiBsIGo7hGFcbgbTQNSVyZArlIxxMtnS2KWsbMA3kwZIykoxbbwl3Ayal3qFC2ym+Of4YmhqGqSnmnbPEe8+79Dlgb1fVbio8Qapx/L1+ppzq1Kj8c5S9XkgAAAA2KN5cUfcqy9Hujo22s5ajXhj80ehxgB6uNwpxUoSUk+6IubZ561up208x3i+sfM7dGtCtTU4PKf/AAC3ITMZRCU/ICeQVcQA7ssGnXjvsX5yHgDS8SONq145SdCm9l77Xf4HV1e5Vrb+HHMntH9zy7eXuBgAAAAAAAAAAC+0uHQqZ/xfvIoAHoFLiimnlNZTBo6bW4oulJ7x3Xob+AMAshTcu2wA6SZPqYAHl9auOdeyS92n4V9zngAAAAAAAAAAAAAAFtrU5VeE+ye/oeop0Y9c5AAvUUuwAA//2Q==",
                jabatan: "Karyawan",
                Divisi: "Produksi",
                email: "berli@gmail.com",
                tempatTgl: "Bandung 21-09-2005"
            },
        ],
    }),
    computed: {
        pageTitle() {
            return this.Trans.chose(this.AppConfig.packageLocal.modhr.access.children.customer.caption);
        },
        formTitle() {
            return this.isAdd ? "Tambah Baru" : "Edit";
        },
        listData() {
            return this.$store.state.modhrClient.listData;
        },
        oneData() {
            return this.$store.state.modhrClient.oneData;
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

                this.$store.dispatch("modhrClient/readList", {params: this.loadParams}).then(res => {
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
                        .dispatch("modhrClient/readOne", {id:id})
                        .then(res => {
                            this.form = this.oneData;
                            this.$bvModal.show("modals-form");
                        })
                        .catch(res => {
                            console.log("get modhrClient error : ", res);
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
                    .dispatch("modhrClient/create", {data:data})
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
                    .dispatch("modhrClient/update", {data:data,id:data.id})
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
                            .dispatch("modhrClient/delete", {id:id})
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
            this.Web.appendNavbarTitle(this.Trans.chose(this.AppConfig.packageLocal.modhr.access.children.customer.caption));

            //reload list data
            this.loadList();
            this.form = JSON.parse(JSON.stringify(this.formEmpty));
        }
};
</script>

<style>
    .divisi{
        font-family: monospace;
        font-style: normal;
        font-size: 17px;
    }
    .jabatan{
        font-family: Arial, Helvetica, sans-serif;
        font-style: italic;
        font-size: 15px;
        color: rgba(119, 101, 5, 1);
    }
</style>
