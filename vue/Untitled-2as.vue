<template>
    <div>
      <b-form @submit="onSubmit" @reset="onReset" v-if="show">
        <b-form-group
          id="input-group-1"
          label="nama division :"
          label-for="input-1"
          description="We'll never share your email with anyone else."
        >
          <b-form-input
            id="input-1"
            v-model="form.nama"
            type="text"
            placeholder="Enter nama"
            required
          ></b-form-input>
        </b-form-group>
  
        <b-form-group id="input-group-2" label="Description:" label-for="input-2">
          <b-form-textarea
        id="textarea"
        v-model="form.desc"
        placeholder="Enter something..."
        rows="3"
        max-rows="6"
      ></b-form-textarea>
        </b-form-group>
  
        <b-form-group id="input-group-3" label="Level:" label-for="input-3">
         <b-form-input
            id="input-1"
            v-model="form.level"
            type="number"
            placeholder="Enter Level"
            required
          ></b-form-input>
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
      name : "modhr.division.form",
        data() {
      return {
        form: {
          nama: '',
          desc: '',
          level: '',
          checked: []
        },
        foods: [{ text: 'Select One', value: null }, 'Carrots', 'Beans', 'Tomatoes', 'Corn'],
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
        this.form.desc = ''
        this.form.level = ''
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      }
    }
    }
</script>