<template>
    <div class="container">
        <b-row>
            <b-col cols="8">
                <b-card>
                    <b-card-text>
                        <b-row class="fs-5">
                            <b-col>
                                <h6>Nama Project: name Project</h6>
                                <h6>Descriotion: </h6>
                            </b-col>
                            <b-col>
                                <p class="text-right mb-0">
                                    <b class="text-right">Internal</b>
                                </p>
                                <div class="conten mb-3">
                                    Project Division : project Divisi <br>
                                    Project Category : Gevorment
                                </div>

                            </b-col>
                        </b-row>
                        <p>Lorem ipsum dolor, sit amet consectetur adipisicing elit. Culpa nemo, rem itaque delectus
                            dolor adipisci, laudantium quo corporis qui praesentium dicta hic totam ratione nam odio!
                            Reiciendis illo quia esse. Lorem ipsum dolor sit amet consectetur adipisicing elit. Iure
                            sunt nulla molestias fuga eum consequuntur, vitae quidem at dolore cum laudantium
                            repudiandae fugiat non alias architecto! Corrupti magnam error qui?</p>
                    </b-card-text>
                </b-card>
            </b-col>
            <b-col>
                <!-- member project -->
                <b-card style="min-height: 250px;">

                </b-card>
            </b-col>
        </b-row>
        <hr>
        <b-row>
            <b-col>
                <b-card no-body>
                    <!-- Table controls -->
                    <b-card-body class="pb-2 pt-2">
                        <div class="row">
                            <div class="col">
                                <b-form-group :label="Trans.get('pagination.per_page')"
                                    class="d-inline-block w-auto mt-1">
                                    <b-select v-model="perPage" :options="perPageOption" />
                                </b-form-group>
                                <b-form-group :label="Trans.get('lang.search')" class="d-inline-block w-auto mt-1">
                                    <b-input placeholder="Search..." v-model="searchString" />
                                </b-form-group>
                                <b-btn variant="info" @click="doSearch" style="margin-top: -3px"
                                    class="d-inline-block w-auto">
                                    <span class="ion ion-ios-search"></span>
                                </b-btn>
                            </div>
                        </div>
                    </b-card-body>
                    <!-- / Table controls -->

                    <!-- Table -->
                    <!-- <hr class="border-light m-0" /> -->
                    <div class="table-responsive mb-0">
                        <b-table :items="listData.data" :fields="fields" :sort-by.sync="sortBy"
                            :sort-desc.sync="sortDesc" :striped="true" :bordered="true" :small="true" :responsive="true"
                            class="card-table mb-0" :empty-text="noResultsText" show-empty>
                            <template v-slot:empty="scope">
                                <h5 class="text-center mb-1 mt-1">{{ scope.emptyText }}</h5>
                            </template>

                            <template v-slot:cell(no)="data">
                                {{ data.index + 1 + (curPage - 1) * perPage }}
                            </template>



                            <template v-slot:cell(actions)="data">
                                <b-btn @click="showForm(false, data.item.id)"
                                    variant="default btn-xs icon-btn md-btn-flat" v-b-tooltip.hover.left
                                    :title="Trans.get('lang.edit')" v-if="UserAuth.hasAccess(accessRuleKey, 'u')">
                                    <i class="ion ion-md-create"></i>
                                </b-btn>
                                <b-btn @click="deleteData(data.item.id)" variant="danger btn-xs icon-btn md-btn-flat"
                                    v-b-tooltip.hover.left title="Remove" v-if="UserAuth.hasAccess(accessRuleKey, 'd')">
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
                                <b-pagination class="justify-content-center justify-content-sm-end m-0"
                                    v-model="curPage" :total-rows="listData.count" :per-page="perPage" size="sm" />
                            </div>
                        </div>
                    </b-card-body>
                    <!-- / Pagination -->
                </b-card>
            </b-col>
        </b-row>
    </div>
</template>

<script>
import { required, email1 } from "node_modules/vuelidate/lib/validators";
export default {
    name: "modpm-project-master-category",
    validations: {
        form: {
            name: {
                required,
            },
        },
    },
    data: () => ({
        isAdd: true, //flag untuk form input, apakah proses add atau edit
        defaultModalSize: "md",
        accessRuleKey: "modpm.project",

        // Options
        searchString: "",
        sortBy: "id",
        sortDesc: false,
        perPage: 10,
        curPage: 1,
        perPageOption: [10, 20, 50, 100],
        noResultsText: "Loading...",
        loadParams: {},

        fields: [
            { key: "no", sortable: false, tdClass: "text-center text-nowrap" },
            {
                key: "name",
                label: "nama",
                sortable: true,
                thStyle: "min-width: 5rem",
                thClass: "text-center",
            },
            // { key: "level",label:"Level", sortable: true, thStyle: "min-width: 5rem" , thClass:"text-center"},
            {
                key: "description",
                sortable: true,
                thStyle: "min-width: 10rem",
                thClass: "text-center",
            },
            { key: "actions", label: " action ", tdClass: "text-center text-nowrap" },
        ],

        formEmpty: {
            id: 0,
            name: "",
            description: "",
        },
        form: "",
    }),
    created() {
        if (!this.UserAuth.hasAccess(this.accessRuleKey)) {
            //goto dashboard current tenant
            this.Web.goToCurrentTenant();
            this.Web.showAlert({
                title: this.Trans.get("alert.warning_title"),
                text: this.Trans.get("alert.access_denied"),
                type: "warning",
            });
            return false;
        }
        //jika tidak punya access edit/delete maka hilangkan kolom aksi
        if (
            !(
                this.UserAuth.hasAccess(this.accessRuleKey, "u") ||
                this.UserAuth.hasAccess(this.accessRuleKey, "d")
            )
        ) {
            this.fields.splice(4, 1);
        }

        this.initView();
        this.loadList();
    },
    watch: {
        curPage(v) {
            this.loadList(v, this.searchString, this.sortBy, this.sortDesc);
        },
        perPage(v) {
            this.loadList(
                this.curPage,
                this.searchString,
                this.sortBy,
                this.sortDesc
            );
        },
        sortBy(v) {
            this.loadList(this.curPage, this.searchString, v, this.sortDesc);
        },
        sortDesc(v) {
            this.loadList(this.curPage, this.searchString, this.sortBy, v);
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
        viewData: {
            get() {
                return this.$store.state.modpmProjectView.project;
            },
            set(value) {
                this.$store.commit("modpmProjectView/setProject", value);
            },
        },
        pageTitle() {
            return this.Trans.chose(
                this.AppConfig.packageLocal.modpm.access.children.master.children
                    .category.caption
            );
        },
        formTitle() {
            return this.isAdd ? "Tambah Baru" : "Edit";
        },
        listData() {
            return this.$store.state.modpmProjectCategory.listCategory;
        },
        oneData() {
            return this.$store.state.modpmProjectCategory.oneCategory;
        },
        totalPages() {
            return Math.ceil(this.listData.count / this.perPage);
        },
    },
    methods: {
        initView() {
            this.Web.setNavbarTitle("Project Category");
            this.Web.resetBreadcrumb();
            this.Web.addBreadcrumb(
                this.Trans.chose(
                    this.AppConfig.packageLocal.modpm.access.children.project.caption
                )
            );
            this.Web.addBreadcrumb("Project Category");
        },
        doSearch() {
            this.loadList(
                this.curPage,
                this.searchString,
                this.sortBy,
                this.sortDesc
            );
        },
        loadList(curPage = 1, q = "", orderBy = false, sortDesc = false) {
            var offset = this.perPage * (curPage - 1);

            this.loadParams.limit = this.perPage;
            this.loadParams.offset = offset;

            if (q != "") {
                this.loadParams.q = q;
            } else {
                delete this.loadParams.q;
            }
            if (orderBy != false) {
                this.loadParams.orderBy = orderBy;
                this.loadParams.orderType = sortDesc ? "DESC" : "ASC";
            }

            this.$store
                .dispatch("modpmProjectCategory/readListCategory", {
                    params: this.loadParams,
                })
                .then((res) => {
                    if (this.listData.count == 0) {
                        this.noResultsText = this.Trans.get("lang.no_data");
                        this.Web.showAlert({
                            title: this.Trans.get("alert.info_title"),
                            text: this.Trans.get("lang.no_data"),
                            type: "info",
                        });
                    }
                })
                .catch((res) => {
                    this.Web.showAlert({
                        title: this.Trans.get("alert.warning_title"),
                        text:
                            this.Trans.get("alert.read_failed", {
                                attribute: this.Trans.get("crm.client"),
                            }) +
                            "<br>\n" +
                            res.message,
                        type: "warning",
                    });
                });
        },
        showForm(isAdd = true, id = 0) {
            this.isAdd = isAdd;
            if (!isAdd) {
                this.$store
                    .dispatch("modpmProjectCategory/readOneCategory", { id: id })
                    .then((res) => {
                        this.form = this.oneData;
                        this.$bvModal.show("modals-form");
                    })
                    .catch((res) => {
                        console.log("get modpmProjectCategory error : ", res);
                        this.Web.showAlert({
                            title: this.Trans.get("alert.warning_title"),
                            text:
                                this.Trans.get("alert.read_failed", {
                                    attribute: this.Trans.get("crm.client"),
                                }) +
                                "<br>\n" +
                                res.message,
                            type: "warning",
                        });
                    });
            } else {
                this.form = JSON.parse(JSON.stringify(this.formEmpty));
                this.$bvModal.show("modals-form");
            }
        },
        formSubmitted(ev) {
            ev.preventDefault();
            if (this.$v) {
                this.$v.$touch();
                if (this.$v.$error) {
                    this.Web.showAlert({
                        title: this.Trans.get("alert.form_must_complete_title"),
                        text: this.Trans.get("alert.form_must_complete_text"),
                        type: "warning",
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
                    type: "warning",
                });
                return false;
            }

            this.Web.setLoadingPage(true);
            this.$store
                .dispatch("modpmProjectCategory/createCategory", { data: data })
                .then((res) => {
                    this.Web.showAlert({
                        title: this.Trans.get("alert.success_title"),
                        text: this.Trans.get("alert.create_success", {
                            attribute: this.Trans.get("crm.client"),
                        }),
                        type: "success",
                    });
                    this.$bvModal.hide("modals-form");
                    this.Web.setLoadingPage(false);
                })
                .catch((res) => {
                    this.Web.showAlert({
                        title: this.Trans.get("alert.warning_title"),
                        text:
                            this.Trans.get("alert.create_failed", {
                                attribute: this.Trans.get("crm.client"),
                            }) +
                            "<br>\n" +
                            res.message,
                        type: "warning",
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
                    type: "warning",
                });
                return false;
            }

            this.Web.setLoadingPage(true);
            this.$store
                .dispatch("modpmProjectCategory/updateCategory", {
                    data: data,
                    id: data.id,
                })
                .then((res) => {
                    this.Web.showAlert({
                        title: this.Trans.get("alert.success_title"),
                        text: this.Trans.get("alert.update_success", {
                            attribute: this.Trans.get("crm.client"),
                        }),
                        type: "success",
                    });
                    this.$bvModal.hide("modals-form");
                    this.Web.setLoadingPage(false);
                })
                .catch((res) => {
                    this.Web.showAlert({
                        title: this.Trans.get("alert.warning_title"),
                        text:
                            this.Trans.get("alert.update_failed", {
                                attribute: this.Trans.get("crm.client"),
                            }) +
                            "<br>\n" +
                            res.message,
                        type: "warning",
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
                    type: "warning",
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
                        .dispatch("modpmProjectCategory/deleteCategory", { id: id })
                        .then((res) => {
                            this.Web.showAlert({
                                title: this.Trans.get("alert.success_title"),
                                text: this.Trans.get("alert.delete_success", {
                                    attribute: this.Trans.get("crm.client"),
                                }),
                                type: "success",
                            });
                        })
                        .catch((res) => {
                            this.Web.showAlert({
                                title: this.Trans.get("alert.warning_title"),
                                text:
                                    this.Trans.get("alert.delete_failed", {
                                        attribute: this.Trans.get("crm.client"),
                                    }) +
                                    "<br>\n" +
                                    res.message,
                                type: "warning",
                            });
                        });
                },
            });
        },
    },
};
</script>