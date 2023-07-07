using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LifeIsPain : MonoBehaviour
{
    private Rigidbody2D imnothing;
    private Animator pain;
    private void Start()
    {
        imnothing = GetComponent<Rigidbody2D>();
        pain = GetComponent<Animator>();
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("IWantToDie")) 
        {
            Die();
        }
    }
    private void Die()
    {
        imnothing.bodyType = RigidbodyType2D.Static;
        pain.SetTrigger("death");
    }

    private void ThePainIsBack()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
}
