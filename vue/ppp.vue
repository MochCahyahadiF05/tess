<template>
    <div>
      <b-form @submit="onSubmit" @reset="onReset" v-if="show">
        <b-form-group
          id="input-group-1"
          label="Nama:"
          label-for="input-1"
        >
          <b-form-input
            id="input-1"
            v-model="form.nama"
            type="text"
            placeholder="Masukan Nama Anda"
            required
          ></b-form-input>
        </b-form-group>
  
        <b-form-group id="input-group-2" label="Tanggal lahir:" label-for="input-2">
          <b-form-input
            id="input-2"
            v-model="form.tgl"
            type="date"
          ></b-form-input>
        </b-form-group>
  
        <b-form-group id="input-group-4" label="Tempat lahir:" label-for="input-2">
          <b-form-input
            id="input-4"
            v-model="form.pob"
            type="text"
          ></b-form-input>
        </b-form-group>
       
  
        <b-form-group id="input-group-3" v-slot="{ ariaDescribedby }" label="Jenis Kelamin">
          <b-form-radio-group
            v-model="form.jk"
            id="radio-3"
            :aria-describedby="ariaDescribedby"
                              required
          >
            <b-form-radio value="laki-laki">Laki-laki</b-form-radio>
            <b-form-radio value="perempuan">Perempuan</b-form-radio>
          </b-form-radio-group>
        </b-form-group>
        
        <b-form-group id="input-group-5" label="Status Kepegawaian" label-for="input-5">
          <b-form-select
            id="input-5"
            v-model="form.status"
            :options="statuss"
            required
          ></b-form-select>
        </b-form-group>
        
        <b-form-group id="input-group-6" label="Jabatan:" label-for="input-6">
          <b-form-select
            id="input-6"
            v-model="form.jabatan"
            :options="jabatans"
            required
          ></b-form-select>
        </b-form-group>
        
        <b-form-group id="input-group-7" label="Divisi:" label-for="input-7">
          <b-form-select
            id="input-7"
            v-model="form.divisi"
            :options="divisis"
            required
          ></b-form-select>
        </b-form-group>
        
        <b-form-group   label="Avatar">
                <b-form-file
        v-model="form.avatar"
        :state="Boolean(form.avatar)"
        placeholder="Choose a image or drop it here..."
        drop-placeholder="Drop Image here..."
      ></b-form-file>
          <p>
            {{ form.avatar ? form.avatar.name : '' }}
          </p>
        </b-form-group>
        
        <b-form-group id="input-group-9" label="Status Akun:" label-for="input-9">
          <b-form-select
            id="input-9"
            v-model="form.statusAkun"
            :options="akuns"
            required
          ></b-form-select>
        </b-form-group>
  
        <b-button type="submit" variant="primary">Submit</b-button>
        <b-button type="reset" variant="danger">Reset</b-button>
      </b-form>
      <b-card class="mt-3" header="Form Data Result">
        <pre class="m-0">{{ form }}</pre>
      </b-card>
    </div>
</template>

<script>
  
    export default {
      name:'pages-employee-form',
        data() {
      return {
        form: {
          nama: '',
          tgl: '',
          pob:'',
          jk: '',
          status: null,
          jabatan: null,
          divisi:null,
          avatar:null,
          statusAkun:null
        },
        statuss: 	[
          				{ text: 'Status Kepegawaian', value: null }, 
                  {text:'Keluar',value: 'Keluar'},
                  {text:'Pegawai Aktif',value:'Pegawai Aktif'},
                  {text:'Cuti', value:'cuti'}
        					],
        jabatans: [
          				{ text: 'Select Jabatan', value: null },
                  { text: 'Direktur', value:"0"},
                  { text: 'Manager', value:"1"}, 
                  { text: 'Karyawan',value:"2"}
                  ],
        divisis: [
          				{ text: 'Select Divisi', value: null },
                  { text: 'Produksi', value:"0"},
                  { text: 'Marketing', value:"1"}, 
                  { text: 'Pelayanan',value:"2"}
                  ],
        akuns: [
          				{ text: 'Select Status Akun', value: null },
                  { text: 'Tidak Aktif', value:"0"},
                  { text: 'Aktif', value:"1"}, 
                  { text: 'Banned',value:"2"}
                  ],
        show: true
      }
    },
    methods: {
      onSubmit(event) {
        event.preventDefault()
        alert(JSON.stringify(this.form))
      },
      onReset(event) {
        event.preventDefault()
        // Reset our form values
        this.form.nama = ''
        this.form.tgl = ''
        this.form.pob =''
        this.form.jk = []
        this.form.status=null
        this.form.jabatan = null
        this.form.divisi = null
        this.form.avatar = null
        this.form.statusAkun = null
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      }
    }
    }
</script>
